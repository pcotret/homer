-----------------------------------------------------------------
-- Author: Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decoder_tb is
end entity;

architecture bhv of instruction_decoder_tb is

  constant HALF_PERIOD : time := 5 ns;
  constant INSTR_SIZE  : natural := 16;
  constant REG_NB      : natural := 4;
  constant REG_SIZE    : natural := 16;

  signal clk     : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal en       : std_logic;
  signal instr_in : std_logic_vector(INSTR_SIZE - 1 downto 0);
  signal reg_src1 : std_logic_vector(REG_NB - 1 downto 0);
  signal reg_src2 : std_logic_vector(REG_NB - 1 downto 0);
  signal reg_dst  : std_logic_vector(REG_NB - 1 downto 0);
  signal imm      : std_logic_vector(REG_SIZE - 1 downto 0);
  signal wr_en    : std_logic;
  signal opcode   : std_logic_vector(3 downto 0);

begin
  -------------------------------------------------------------------
  -- clock
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.instruction_decoder(bhv)
        generic map(
          INSTR_SIZE => 16,
          REG_NB => 4,
          REG_SIZE => 16)
        port map (
          clk      => clk     ,
          en       => en      ,
          instr_in => instr_in,
          reg_src1 => reg_src1,
          reg_src2 => reg_src2,
          reg_dst  => reg_dst ,
          imm      => imm     ,
          wr_en    => wr_en   ,
          opcode   => opcode  
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for instruction_decoder(bhv)";
     report "applying stimuli...";
     -- Initial state
     en       <= '0';
     instr_in <= (others => '0');
     wait_cycles(2);
     -- Instruction, decoder disabled
     instr_in <= x"CAFE";
     wait_cycles(2);
     -- Decoder enabled
     en <= '1';
     wait_cycles(2);
     -- Another instruction
     instr_in <= x"B41D";
     wait_cycles(2);
     -- Jump instruction, where write enable is equal to 0
     instr_in <= x"4000"; -- Jump opcode padded with 0
     wait_cycles(2);
     -- Back to an instruction with write_enable=1
     instr_in <= x"B41D";
     wait_cycles(2);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
