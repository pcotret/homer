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
         imm_in       : in  std_logic_vector(REG_WIDTH-1 downto 0);
         wr_en_in     : in  std_logic;
         pc_value_in  : in  std_logic_vector(REG_WIDTH-1 downto 0);
         wr_reg_out   : out std_logic;
         branch_out   : out std_logic;
         dst_reg_out  : out std_logic_vector(REG_WIDTH-1 downto 0)
        );
end entity alu;

-- Architecture
architecture bhv of alu is
-- +2 for the carry and the eventual overflow
signal result_s : std_logic_vector(REG_WIDTH+2 downto 0) := (others => '0');
-- Intermediate branch signal
signal branch_s : std_logic := '0';

-- Register file
begin
    process(clk)
    begin
        if rising_edge(clk) and en='1' then
            wr_reg_out <= wr_en_in;
            case(opcode_in) is
                when OPC_ADD => -- Addition
                if opcode_in(0)='0' then -- Add for unsigned values
                    result_s(REG_WIDTH downto 0) <= std_logic_vector(unsigned('0' & src1_reg_in) + unsigned('0' & src2_reg_in));    
                else -- Add for signed values
                    result_s(REG_WIDTH downto 0) <= std_logic_vector(signed(src1_reg_in(REG_WIDTH-1) & src1_reg_in) + signed(src2_reg_in(REG_WIDTH-1) & src2_reg_in));
                end if;
                branch_s <= '0';

                when OPC_SUB => -- Substraction
                if opcode_in(0)='0' then -- Sub for unsigned values
                    result_s(REG_WIDTH downto 0) <= std_logic_vector(unsigned('0' & src1_reg_in) - unsigned('0' & src2_reg_in));    
                else -- Sub for signed values
                    result_s(REG_WIDTH downto 0) <= std_logic_vector(signed(src1_reg_in(REG_WIDTH-1) & src1_reg_in) - signed(src2_reg_in(REG_WIDTH-1) & src2_reg_in));
                end if;
                branch_s <= '0';

                when OPC_READ => 	
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(signed(src1_reg_in) + signed(imm_in(4 downto 0)));
                branch_s <= '0';
                
                when OPC_WRITE => 
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(signed(src1_reg_in) + signed(imm_in(REG_WIDTH-1 downto REG_WIDTH-5)));
                branch_s <= '0';

                when OPC_LOAD => -- Load immediate value in a register
                if opcode_in(0)='0' then -- Load most significant byte
                    result_s(REG_WIDTH-1 downto 0) <= imm_in(7 downto 0) & x"00";
                else -- Load least significant byte
                    result_s(REG_WIDTH-1 downto 0) <= x"00" & imm_in(7 downto 0);
                end if;
                branch_s <= '0';
                
                when OPC_COMPARE => -- Compare two registers
                if src1_reg_in = src2_reg_in then -- When those two registers are equal
                    result_s <= (others => '1');
                else -- When registers are different
                    result_s <= (others => '0');
                end if;
                branch_s <= '0';

                when OPC_SL => -- Shift left: src2 is shifted according to the least significants bits of src1
                case src1_reg_in(3 downto 0) is
                when x"1" => -- Shift left by 1 bit
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 1));
                when x"2" => -- Shift left by 2 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 2));
                when x"3" => -- Shift left by 3 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 3));
                when x"4" => -- Shift left by 4 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 4));
                when x"5" => -- Shift left by 5 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 5));
                when x"6" => -- Shift left by 6 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 6));
                when x"7" => -- Shift left by 7 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 7));
                when x"8" => -- Shift left by 8 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 8));
                when x"9" => -- Shift left by 9 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 9));
                when x"A" => -- Shift left by 10 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 10));
                when x"B" => -- Shift left by 11 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 11));
                when x"C" => -- Shift left by 12 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 12));
                when x"D" => -- Shift left by 13 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 13));
                when x"E" => -- Shift left by 14 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 14));
                when x"F" => -- Shift left by 15 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_left(unsigned(src2_reg_in), 15));
                when others =>
                result_s(REG_WIDTH-1 downto 0) <= src2_reg_in;
                end case;
                branch_s <= '0';

                when OPC_SR => -- Shift right: src2 is shifted according to the least significants bits of src1
                case src1_reg_in(3 downto 0) is
                when x"1" => -- Shift right by 1 bit
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 1));
                when x"2" => -- Shift right by 2 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 2));
                when x"3" => -- Shift right by 3 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 3));
                when x"4" => -- Shift right by 4 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 4));
                when x"5" => -- Shift right by 5 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 5));
                when x"6" => -- Shift right by 6 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 6));
                when x"7" => -- Shift right by 7 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 7));
                when x"8" => -- Shift right by 8 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 8));
                when x"9" => -- Shift right by 9 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 9));
                when x"A" => -- Shift right by 10 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 10));
                when x"B" => -- Shift right by 11 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 11));
                when x"C" => -- Shift right by 12 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 12));
                when x"D" => -- Shift right by 13 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 13));
                when x"E" => -- Shift right by 14 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 14));
                when x"F" => -- Shift right by 15 bits
                result_s(REG_WIDTH-1 downto 0) <= std_logic_vector(shift_right(unsigned(src2_reg_in), 15));
                when others =>
                result_s(REG_WIDTH-1 downto 0) <= src2_reg_in;
                end case;
                branch_s <= '0';
                
                when OPC_JUMP => -- Jump
                result_s(REG_WIDTH-1 downto 0) <= src2_reg_in;
                branch_s <= '1';

                when OPC_JUMPCOND => -- Conditional jump
                result_s(REG_WIDTH-1 downto 0) <= src2_reg_in;
                case(opcode_in(0) & imm_in(1 downto 0)) is
                    when "100" =>
                    branch_s <= src1_reg_in(REG_WIDTH-1);
                    when others =>
                    branch_s <= '0';
                end case;

                when OPC_OR => -- Boolean OR
                result_s(REG_WIDTH-1 downto 0) <= src1_reg_in or src2_reg_in;
                branch_s <= '0';
                
                when OPC_XOR => -- Boolean XOR
                result_s(REG_WIDTH-1 downto 0) <= src1_reg_in xor src2_reg_in;
                branch_s <= '0';
                
                when OPC_AND => -- Boolean AND
                result_s(REG_WIDTH-1 downto 0) <= src1_reg_in and src2_reg_in;
                branch_s <= '0';
                
                when OPC_NOT => -- Boolean NOT
                result_s(REG_WIDTH-1 downto 0) <= not(src1_reg_in);
                branch_s <= '0';
                
                when others => -- Do nothing
                result_s <= (others => '0');
                branch_s <= '0';
            end case;
        end if;
    end process;
    -- Exporting the computed result
    dst_reg_out <= result_s(REG_WIDTH-1 downto 0);
    -- Exporting the branch feature of the instruction
    branch_out <= branch_s;
end architecture bhv;