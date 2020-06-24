-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

-- Entity
entity reg_file is
    generic(REG_WIDTH : natural := 16;
            SIZE      : natural := 4);
    port(clk          : in  std_logic;
         en           : in  std_logic;
         wr_en        : in  std_logic;
         src1_sel_in  : in  std_logic_vector(SIZE-1 downto 0);
         src1_reg_out : out std_logic_vector(REG_WIDTH-1 downto 0);
         src2_sel_in  : in  std_logic_vector(SIZE-1 downto 0);
         src2_reg_out : out std_logic_vector(REG_WIDTH-1 downto 0);
         dst_sel_in   : in  std_logic_vector(SIZE-1 downto 0);
         dst_reg_in   : in  std_logic_vector(REG_WIDTH-1 downto 0)
        );
end entity reg_file;

-- Architecture
architecture bhv of reg_file is
-- Register file
type register_file is array (0 to 2**SIZE-1) of std_logic_vector(REG_WIDTH-1 downto 0);
signal reg_bank: register_file := (others => x"0000");
begin
    process(clk)
    begin
        if rising_edge(clk) and en='1' then
            src1_reg_out <= reg_bank(to_integer(unsigned(src1_sel_in)));
            src2_reg_out <= reg_bank(to_integer(unsigned(src2_sel_in)));
            if (wr_en = '1') then
                reg_bank(to_integer(unsigned(dst_sel_in))) <= dst_reg_in;
            end if;
        end if;
    end process;
end architecture bhv;