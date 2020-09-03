-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;

-- Entity
entity homer_fsm is
    port(clk_in    : in  std_logic;
         reset_in  : in  std_logic;
         state_out : out std_logic_vector(3 downto 0)
        );
end entity homer_fsm;

-- Architecture
architecture bhv of homer_fsm is
signal state_s: std_logic_vector(3 downto 0);
begin
process(clk_in)
begin
    if clk_in'event and clk_in='1' then
        if reset_in = '1' then
            state_s <= "0001";
        else
            case state_s is
            when "0001" => -- en_decode
            state_s <= "0010"; -- to regread
            when "0010" => -- en_regread
            state_s <= "0100"; -- to alu
            when "0100" => -- en_alu
            state_s <= "1000"; -- to regwrite
            when "1000" => -- en_regwrite
            state_s <= "0001"; -- to decode
            when others =>
            state_s <= "0001"; -- to decode
            end case;
        end if;
    end if;
end process;
state_out <= state_s;
end bhv;