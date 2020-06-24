-----------------------------------------------------------------
-- Author: Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_and_pc_tb is
end entity;

architecture bhv of ram_and_pc_tb is

  constant HALF_PERIOD : time    := 5 ns;
  constant INSTR_SIZE  : natural := 16;
  constant ADDR_SIZE   : natural := 16;

  signal clk     : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal pc_operation : std_logic_vector(1 downto 0);
  signal pc_in        : std_logic_vector(ADDR_SIZE-1 downto 0);
  signal data_out     : std_logic_vector(INSTR_SIZE-1 downto 0);

begin
  -------------------------------------------------------------------
  -- clock
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.ram_and_pc(bhv)
        generic map(
          ADDR_SIZE  => 16,
          INSTR_SIZE => 16)
        port map (
          clk_in       => clk       ,
          pc_operation => pc_operation ,
          pc_in        => pc_in        ,
          data_out     => data_out
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for ram_memory(bhv)";
     report "applying stimuli...";
     -- Initial state
     pc_in <= x"0003";
     pc_operation <= "11"; -- PC reset
     wait_cycles(4);
     -- Increment program counter
     pc_operation <= "01";
     wait_cycles(4);
     -- Write program counter
     pc_operation <= "10";
     wait_cycles(4);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
