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

-- Register file
begin
    process(clk,en)
    begin
        if rising_edge(clk) and en='1' then
            case(opcode_in) is

                when OPC_XOR => -- Boolean XOR
                result_s <= src1_reg_in xor src2_reg_in;
                
                when OPC_AND => -- Boolean AND
                result_s <= src1_reg_in and src2_reg_in;

                when OPC_NOT => -- Boolean NOT
                result_s <= not(src1_reg_in);

                when OPC_OR => -- Boolean OR
                result_s <= src1_reg_in or src2_reg_in;
                
                when OPC_COMPARE => -- Compare two registers
                if src1_reg_in = src2_reg_in then -- When those two registers are equal
                    result_s <= (others => '1');
                else -- When registers are different
                    result_s <= (others => '0');
                end if;
                
                when OPC_SL => -- Shift left: src2 is shifted according to the least significants bits of src1
                case src1_reg_in(3 downto 0) is
                when x"1" => -- Shift left by 1 bit
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 1));
                when x"2" => -- Shift left by 2 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 2));
                when x"3" => -- Shift left by 3 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 3));
                when x"4" => -- Shift left by 4 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 4));
                when x"5" => -- Shift left by 5 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 5));
                when x"6" => -- Shift left by 6 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 6));
                when x"7" => -- Shift left by 7 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 7));
                when x"8" => -- Shift left by 8 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 8));
                when x"9" => -- Shift left by 9 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 9));
                when x"A" => -- Shift left by 10 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 10));
                when x"B" => -- Shift left by 11 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 11));
                when x"C" => -- Shift left by 12 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 12));
                when x"D" => -- Shift left by 13 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 13));
                when x"E" => -- Shift left by 14 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 14));
                when x"F" => -- Shift left by 15 bits
                result_s <= std_logic_vector(shift_left(unsigned(src2_reg_in), 15));
                when others =>
                result_s <= src2_reg_in;
                end case;

                when OPC_SR => -- Shift right: src2 is shifted according to the least significants bits of src1
                case src1_reg_in(3 downto 0) is
                when x"1" => -- Shift right by 1 bit
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 1));
                when x"2" => -- Shift right by 2 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 2));
                when x"3" => -- Shift right by 3 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 3));
                when x"4" => -- Shift right by 4 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 4));
                when x"5" => -- Shift right by 5 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 5));
                when x"6" => -- Shift right by 6 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 6));
                when x"7" => -- Shift right by 7 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 7));
                when x"8" => -- Shift right by 8 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 8));
                when x"9" => -- Shift right by 9 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 9));
                when x"A" => -- Shift right by 10 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 10));
                when x"B" => -- Shift right by 11 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 11));
                when x"C" => -- Shift right by 12 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 12));
                when x"D" => -- Shift right by 13 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 13));
                when x"E" => -- Shift right by 14 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 14));
                when x"F" => -- Shift right by 15 bits
                result_s <= std_logic_vector(shift_right(unsigned(src2_reg_in), 15));
                when others =>
                result_s <= src2_reg_in;
                end case;
                               
                when others => -- Do nothing
                result_s <= (others => '0');
            end case;
        end if;
    end process;
    -- Exporting the computed result
    dst_reg_out <= result_s;
end architecture bhv;