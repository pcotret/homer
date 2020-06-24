-----------------------------------------------------------------
-- Author: Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_memory_tb is
end entity;

architecture bhv of ram_memory_tb is

  constant HALF_PERIOD : time    := 5 ns;
  constant MEM_SIZE    : natural := 8;
  constant INSTR_SIZE  : natural := 16;

  signal clk     : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal wr_en    : std_logic;
  signal addr_in  : std_logic_vector(MEM_SIZE - 1 downto 0);
  signal data_in  : std_logic_vector(INSTR_SIZE - 1 downto 0);
  signal data_out : std_logic_vector(INSTR_SIZE - 1 downto 0);

begin
  -------------------------------------------------------------------
  -- clock
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.ram_memory(bhv)
        generic map(
          MEM_SIZE => 8,
          INSTR_SIZE => 16)
        port map (
          clk      => clk     ,
          wr_en    => wr_en   ,
          addr_in  => addr_in ,
          data_in  => data_in ,
          data_out => data_out
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for ram_memory(bhv)";
     report "applying stimuli...";
     -- Initial state
     wr_en <= '0';
     addr_in <= (others => '0');
     data_in <= (others => '0');
     wait_cycles(2);
     -- Write 1st memory word
     wr_en <= '1';
     addr_in <= "00000000";
     data_in <= x"CAFE";
     wait_cycles(2);
     -- Write 2nd memory word
     wr_en <= '1';
     addr_in <= "00000001";
     data_in <= x"B41D";
     wait_cycles(2);
     -- Read 1st memory word
     wr_en <= '0';
     addr_in <= "00000000";
     wait_cycles(2);
     -- Read 2nd memory word
     wr_en <= '0';
     addr_in <= "00000001";
     wait_cycles(2);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
