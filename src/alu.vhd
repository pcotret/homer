-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.homer_pack.all;

-- Entity
entity alu is
    generic(REG_WIDTH : natural := 16;
            SIZE      : natural := 4);
    port(clk          : in  std_logic;
         en           : in  std_logic;
         opcode_in    : in  std_logic_vector(3 downto 0);
         src1_reg_in  : in  std_logic_vector(REG_WIDTH-1 downto 0);
         src2_reg_in  : in  std_logic_vector(REG_WIDTH-1 downto 0);
         dst_reg_out  : out std_logic_vector(REG_WIDTH-1 downto 0)
        );
end entity alu;

-- Architecture
architecture bhv of alu is
signal result_s : std_logic_vector(REG_WIDTH-1 downto 0) := (others => '0');
-- Intermediate branch signal
signal branch_s : std_logic := '0';

-- Register file
begin
    process(clk,en)
    begin
        if rising_edge(clk) and en='1' then
            case(opcode_in) is

                when OPC_OR => -- Boolean OR
                result_s <= src1_reg_in or src2_reg_in;
                               
                when others => -- Do nothing
                result_s <= (others => '0');
            end case;
        end if;
    end process;
    -- Exporting the computed result
    dst_reg_out <= result_s(REG_WIDTH-1 downto 0);
end architecture bhv;