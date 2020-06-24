-----------------------------------------------------------------
-- Author : Pascal Cotret, <pascal.cotret@ensta-bretagne.fr>
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.homer_constants.all;

entity program_counter_tb is
end entity;

architecture bhv of program_counter_tb is

  constant HALF_PERIOD : time    := 5 ns;
  constant SIZE        : natural := 16;

  signal clk     : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal pc_operation : std_logic_vector(1 downto 0);
  signal pc_in        : std_logic_vector(SIZE-1 downto 0);
  signal pc_value_out : std_logic_vector(SIZE-1 downto 0);

begin
  -------------------------------------------------------------------
  -- clock
  -------------------------------------------------------------------
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.program_counter(bhv)
        
        port map (
          clk_in       => clk         ,
          pc_operation => pc_operation,
          pc_in        => pc_in       ,
          pc_value_out => pc_value_out
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for program_counter(bhv)";
     report "applying stimuli...";
     -- Initial state
     pc_in <= x"12CD";
     pc_operation <= PC_NOP;
     wait_cycles(2);
     pc_operation <= PC_INC;
     wait_cycles(8);
     pc_operation <= PC_ASSIGN;
     wait_cycles(2);
     pc_operation <= PC_RESET;
     wait_cycles(2);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
