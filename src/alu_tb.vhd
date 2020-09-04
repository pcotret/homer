-----------------------------------------------------------------
-- Author: Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.homer_pack.all;

entity alu_tb is
end entity;

architecture bhv of alu_tb is

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

  signal en          : std_logic;
  signal opcode_in   : std_logic_vector(3 downto 0);
  signal src1_reg_in : std_logic_vector(REG_WIDTH - 1 downto 0);
  signal src2_reg_in : std_logic_vector(REG_WIDTH - 1 downto 0);
  signal dst_reg_out : std_logic_vector(REG_WIDTH - 1 downto 0);

begin
  -------------------------------------------------------------------
  -- clock
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.alu(bhv)
        generic map(
          REG_WIDTH => REG_WIDTH,
          SIZE => SIZE)
        port map (
          clk         => clk        ,
          en          => en         ,
          opcode_in   => opcode_in  ,
          src1_reg_in => src1_reg_in,
          src2_reg_in => src2_reg_in,
          dst_reg_out => dst_reg_out
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for alu(bhv)";
     report "applying stimuli...";
     -- Initial state
     en          <= '0';
     opcode_in   <= (others => '0');
     src1_reg_in <= (others => '0');
     src2_reg_in <= (others => '0');
     wait_cycles(2);
     -- Set default values for source registersnd enable the ALU
     src1_reg_in <= x"ABCD";
     src2_reg_in <= x"0003";
     en          <= '1';
     -- OR instruction
     opcode_in <= OPC_OR;
     wait_cycles(2);
     -- XOR instruction
     opcode_in <= OPC_XOR;
     wait_cycles(2);
     -- AND instruction
     opcode_in <= OPC_AND;
     wait_cycles(2);
     -- AND instruction, with two equal registers
     opcode_in   <= OPC_AND;
     src2_reg_in <= x"ABCD";
     wait_cycles(2);
     -- NOT instruction (on src1_reg_in)
     opcode_in <= OPC_NOT;
     wait_cycles(2);
     -- COMPARE instruction, leading to a KO
     opcode_in <= OPC_COMPARE;
     src1_reg_in <= x"CAFE";
     src2_reg_in <= x"CAFF";
     wait_cycles(2);
     -- COMPARE instruction, leading to a OK
     opcode_in <= OPC_COMPARE;
     src1_reg_in <= x"CAFE";
     src2_reg_in <= x"CAFE";
     wait_cycles(2);
     -- Shift left by 2 bits
     opcode_in <= OPC_SL;
     src1_reg_in <= x"0002";
     src2_reg_in <= x"0001";
     wait_cycles(2);
     -- Shift left by 5 bits
     opcode_in <= OPC_SL;
     src1_reg_in <= x"0005";
     src2_reg_in <= x"0001";
     wait_cycles(2);
     -- Shift right by 5 bits
     opcode_in <= OPC_SR;
     src1_reg_in <= x"0005";
     src2_reg_in <= x"0010";
     wait_cycles(2);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
