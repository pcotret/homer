-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;

package homer_constants is
-- PC unit opcodes
constant PC_NOP    : std_logic_vector(1 downto 0):= "00";
constant PC_INC    : std_logic_vector(1 downto 0):= "01";
constant PC_ASSIGN : std_logic_vector(1 downto 0):= "10";
constant PC_RESET  : std_logic_vector(1 downto 0):= "11";
end package homer_constants;