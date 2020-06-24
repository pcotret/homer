-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;

-- Package
package homer_pack is
    -- Opcodes for Homer
    constant OPC_ADD      : std_logic_vector(3 downto 0) :=  "0000"; -- ADD
    constant OPC_SUB      : std_logic_vector(3 downto 0) :=  "0001"; -- SUB 
    constant OPC_OR       : std_logic_vector(3 downto 0) :=  "0010"; -- OR 
    constant OPC_XOR      : std_logic_vector(3 downto 0) :=  "0011"; -- XOR 
    constant OPC_AND      : std_logic_vector(3 downto 0) :=  "0100"; -- AND 
    constant OPC_NOT      : std_logic_vector(3 downto 0) :=  "0101"; -- NOT 
    constant OPC_READ     : std_logic_vector(3 downto 0) :=  "0110"; -- READ 
    constant OPC_WRITE    : std_logic_vector(3 downto 0) :=  "0111"; -- WRITE 
    constant OPC_LOAD     : std_logic_vector(3 downto 0) :=  "1000"; -- LOAD
    constant OPC_COMPARE  : std_logic_vector(3 downto 0) :=  "1001"; -- COMPARE
    constant OPC_SL       : std_logic_vector(3 downto 0) :=  "1010"; -- SHIFT LEFT
    constant OPC_SR       : std_logic_vector(3 downto 0) :=  "1011"; -- SHIFT RIGHT 
    constant OPC_JUMP     : std_logic_vector(3 downto 0) :=  "1100"; -- JUMP 
    constant OPC_JUMPCOND : std_logic_vector(3 downto 0) :=  "1101"; -- JUMP CONDITIONAL 
end package homer_pack;