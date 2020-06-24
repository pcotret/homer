-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.homer_constants.all;

-- Entity
entity program_counter is
    generic(SIZE : natural := 16);
    port(clk_in       : in  std_logic;
         pc_operation : in  std_logic_vector(1 downto 0);
         pc_in        : in  std_logic_vector(SIZE-1 downto 0);
         pc_value_out : out std_logic_vector(SIZE-1 downto 0)
        );
end entity program_counter;

-- Architecture
architecture bhv of program_counter is
signal pc_value_s : std_logic_vector(SIZE-1 downto 0) := (others => '0');
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            case pc_operation is 
            when PC_NOP => 
            when PC_INC =>
                pc_value_s <= std_logic_vector(unsigned(pc_value_s) + 1);
            when PC_ASSIGN =>
                pc_value_s <= pc_in;
            when PC_RESET =>
                pc_value_s <= X"0000";
            when others =>
            end case;
        end if;
    end process;
    pc_value_out <= pc_value_s;
end bhv;