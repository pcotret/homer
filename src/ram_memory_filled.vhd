-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;
library work;
use work.homer_pack.all;

-- Entity
entity ram_memory_filled is
    generic(MEM_SIZE   : natural := 3;
            INSTR_SIZE : natural := 16);
    port(clk      : in  std_logic;
         wr_en    : in  std_logic;
         addr_in  : in  std_logic_vector(MEM_SIZE-1 downto 0);
         data_in  : in  std_logic_vector(INSTR_SIZE-1 downto 0);
         data_out : out std_logic_vector(INSTR_SIZE-1 downto 0)
        );
end entity ram_memory_filled;

-- Architecture
architecture bhv of ram_memory_filled is
-- Memory itself
  type store_t is array (0 to 7) of std_logic_vector(INSTR_SIZE-1 downto 0);
 signal mem_bank: store_t := (
  OPC_LOAD & "000" & '0' & X"fe",
  OPC_LOAD & "001" & '1' & X"ed",
  OPC_OR & "010" & '0' & "000" & "001" & "00",
  OPC_LOAD & "011" & '1' & X"01",
  OPC_LOAD & "100" & '1' & X"02",
  OPC_ADD & "011" & '0' & "011" & "100" & "00",
  OPC_OR & "101" & '0' & "000" & "011" & "00",
  OPC_AND & "101" & '0' & "101" & "010" & "00"
  );
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