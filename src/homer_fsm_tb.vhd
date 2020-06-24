-----------------------------------------------------------------
-- Author : Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity homer_fsm_tb is
end entity;

architecture bhv of homer_fsm_tb is

  constant HALF_PERIOD : time := 5 ns;

  signal clk     : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal reset_in  : std_logic;
  signal state_out : std_logic_vector(3 downto 0);

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.homer_fsm(bhv)
        
        port map (
          clk_in    => clk      ,
          reset_in  => reset_in ,
          state_out => state_out
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for homer_fsm(bhv)";
     report "applying stimuli...";
     -- Initial state
     reset_in <= '1';
     wait_cycles(4);
     -- Let the FSM running...
     reset_in <= '0';
     wait_cycles(7);
     -- Resetting the FSM
     reset_in <= '1';
     wait_cycles(2);
     -- Running again
     reset_in <= '0';
     wait_cycles(4);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
