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
  signal imm_in      : std_logic_vector(REG_WIDTH - 1 downto 0);
  signal wr_en_in    : std_logic;
  signal pc_value_in : std_logic_vector(REG_WIDTH-1 downto 0);
  signal wr_reg_out  : std_logic;
  signal branch_out  : std_logic;
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
          imm_in      => imm_in     ,
          wr_en_in    => wr_en_in   ,
          pc_value_in => pc_value_in,
          wr_reg_out  => wr_reg_out ,
          branch_out  => branch_out ,
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
     imm_in      <= (others => '0');
     wait_cycles(2);
     -- Enable with a non-supported instruction
     en <= '1';
     src1_reg_in <= x"ABCD";
     src2_reg_in <= x"CAFE";
     imm_in      <= x"1234";
     wait_cycles(2);
     -- ADD instruction
     opcode_in <= OPC_ADD;
     src1_reg_in <= x"0008";
     src2_reg_in <= x"0009";
     wait_cycles(2);
     -- ADD instruction with an overflow
     opcode_in <= OPC_ADD;
     src1_reg_in <= x"FFFE";
     src2_reg_in <= x"0003";
     wait_cycles(2);
     -- SUB instruction
     opcode_in <= OPC_SUB;
     src1_reg_in <= x"0009";
     src2_reg_in <= x"0003";
     wait_cycles(2);
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
     -- NOT instruction
     opcode_in <= OPC_NOT;
     wait_cycles(2);
     -- Read instruction
     opcode_in <= OPC_READ;
     src1_reg_in <= x"AACC";
     imm_in <= x"4363";
     wait_cycles(2);
     -- Write instruction
     opcode_in <= OPC_WRITE;
     src1_reg_in <= x"AACC";
     imm_in <= x"4363";
     wait_cycles(2);
     -- LOAD instruction
     opcode_in <= OPC_LOAD;
     imm_in <= x"BEEF";
     wait_cycles(2);
     -- CMP instruction w/ two equal registers
     opcode_in <= OPC_COMPARE;
     src1_reg_in <= x"1234";
     src2_reg_in <= x"1234";
     wait_cycles(2);
     -- CMP instruction w/ two different registers
     opcode_in <= OPC_COMPARE;
     src1_reg_in <= x"1234";
     src2_reg_in <= x"ABCD";
     wait_cycles(2);
     -- Shift left instruction
     opcode_in <= OPC_SL;
     src1_reg_in <= x"0002";
     src2_reg_in <= x"ABCD";
     wait_cycles(2);
     -- Shift left instruction
     opcode_in <= OPC_SL;
     src1_reg_in <= x"0004";
     src2_reg_in <= x"ABCD";
     wait_cycles(2);
     -- Shift right instruction
     opcode_in <= OPC_SR;
     src1_reg_in <= x"0002";
     src2_reg_in <= x"ABCD";
     wait_cycles(2);
     -- Jump instruction
     opcode_in <= OPC_JUMP;
     src2_reg_in <= x"B4B3";
     wait_cycles(2);
     -- Conditional jump instruction
     opcode_in <= OPC_JUMPCOND;
     src1_reg_in <= x"FFFF";
     src2_reg_in <= x"A12F";
     imm_in <= (others => '0');
     wait_cycles(2);
     -- Conditional jump instruction, no branch
     opcode_in <= OPC_JUMPCOND;
     src1_reg_in <= x"FFFF";
     src2_reg_in <= x"A12F";
     imm_in <= (others => '1');
     wait_cycles(2);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
