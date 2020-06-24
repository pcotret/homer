-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

-- Entity
entity ram_memory is
    generic(MEM_SIZE : natural := 8;
            INSTR_SIZE : natural := 16);
    port(clk      : in  std_logic;
         wr_en    : in  std_logic;
         addr_in  : in  std_logic_vector(MEM_SIZE-1 downto 0);
         data_in  : in  std_logic_vector(INSTR_SIZE-1 downto 0);
         data_out : out std_logic_vector(INSTR_SIZE-1 downto 0)
        );
end entity ram_memory;

-- Architecture
architecture bhv of ram_memory is
-- Memory itself
type memory_file is array (0 to 2**MEM_SIZE-1) of std_logic_vector(INSTR_SIZE-1 downto 0);
signal mem_bank: memory_file := (others => x"0000");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                -- Write in memory
                mem_bank(to_integer(unsigned(addr_in))) <= data_in;
            else
                -- Read from memory
                data_out <= mem_bank(to_integer(unsigned(addr_in)));
            end if;
        end if;
    end process;
end architecture bhv;