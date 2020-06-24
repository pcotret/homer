-----------------------------------------------------------------
-- Author: Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file_tb is
end entity;

architecture bhv of reg_file_tb is

  constant HALF_PERIOD : time    := 5 ns;
  constant REG_WIDTH   : natural := 16;
  constant SIZE        : natural := 4;

  signal clk     : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal en           : std_logic;
  signal wr_en        : std_logic;
  signal src1_sel_in  : std_logic_vector(SIZE - 1 downto 0);
  signal src1_reg_out : std_logic_vector(REG_WIDTH - 1 downto 0);
  signal src2_sel_in  : std_logic_vector(SIZE - 1 downto 0);
  signal src2_reg_out : std_logic_vector(REG_WIDTH - 1 downto 0);
  signal dst_sel_in   : std_logic_vector(SIZE - 1 downto 0);
  signal dst_reg_in   : std_logic_vector(REG_WIDTH - 1 downto 0);

begin
  -------------------------------------------------------------------
  -- clock
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.reg_file(bhv)
        generic map(
          REG_WIDTH => REG_WIDTH,
          SIZE      => SIZE)
        port map (
          clk          => clk          ,
          en           => en           ,
          wr_en        => wr_en        ,
          src1_sel_in  => src1_sel_in  ,
          src1_reg_out => src1_reg_out ,
          src2_sel_in  => src2_sel_in  ,
          src2_reg_out => src2_reg_out ,
          dst_sel_in   => dst_sel_in   ,
          dst_reg_in   => dst_reg_in  
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for reg_file(bhv)";
     report "applying stimuli...";
     -- Initial state
     en          <= '0';
     wr_en       <= '0';
     src1_sel_in <= (others => '0');
     src2_sel_in <= (others => '0');
     dst_sel_in  <= (others => '0');
     dst_reg_in  <= (others => '0');
     wait_cycles(2);
     -- Write 3 first registers
     en    <= '1';
     wr_en <= '1';
     dst_sel_in <= x"0";
     dst_reg_in <= x"BEEF";
     wait_cycles(2);
     dst_sel_in <= x"1";
     dst_reg_in <= x"CAFE";
     wait_cycles(2);
     dst_sel_in <= x"2";
     dst_reg_in <= x"10CC";
     wait_cycles(2);
     -- (src1,src2,dst)=(0,1,0)
     src1_sel_in <= x"0";
     src2_sel_in <= x"1";
     dst_sel_in  <= x"0";
     wait_cycles(2);
     -- (src1,src2,dst)=(1,2,0)
     src1_sel_in <= x"1";
     src2_sel_in <= x"2";
     dst_sel_in  <= x"0";
     wait_cycles(2);
     -- (src1,src2,dst)=(1,4,0). src2 must be 0
     src1_sel_in <= x"1";
     src2_sel_in <= x"4";
     dst_sel_in  <= x"0";
     wait_cycles(2);
     -- (src1,src2,dst)=(0,1,0) with en='0'
     src1_sel_in <= x"0";
     src2_sel_in <= x"1";
     dst_sel_in  <= x"0";
     en          <= '0';
     wait_cycles(2);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
