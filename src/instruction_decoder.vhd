-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;
library work;
use work.homer_pack.all;

-- Entity
entity instruction_decoder is
    generic(INSTR_SIZE : natural := 16;
            REG_NB     : natural := 4;
            REG_SIZE   : natural := 16);
    port(clk      : in  std_logic;
         en       : in  std_logic;
         instr_in : in  std_logic_vector(INSTR_SIZE-1 downto 0);
         reg_src1 : out std_logic_vector(REG_NB-1 downto 0);
         reg_src2 : out std_logic_vector(REG_NB-1 downto 0);
         reg_dst  : out std_logic_vector(REG_NB-1 downto 0);
         imm      : out std_logic_vector(REG_SIZE-1 downto 0);
         wr_en    : out std_logic;
         opcode   : out std_logic_vector(3 downto 0)
        );
end entity instruction_decoder;

-- Architecture
architecture bhv of instruction_decoder is
begin
    process(clk,en)
    begin
        if rising_edge(clk) and en='1' then
            reg_src1 <= instr_in(7 downto 4);
            reg_src2 <= instr_in(3 downto 0);
            reg_dst  <= instr_in(11 downto 8);
            imm      <= instr_in(7 downto 0) & instr_in(7 downto 0);
            opcode   <= instr_in(15 downto 12);        
            case instr_in(15 downto 12) is
            when OPC_WRITE | OPC_JUMP | OPC_JUMPCOND => -- Write, jump + conditional
                wr_en <= '0';
            when others =>
                wr_en <= '1';
            end case;
        end if;
    end process;
end architecture bhv;