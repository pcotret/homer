-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;
library work;
use work.all;

-- Entity
entity ram_and_pc is
    generic(ADDR_SIZE  : natural := 16;
            INSTR_SIZE : natural := 16);
    port(clk_in       : in  std_logic;
         pc_operation : in  std_logic_vector(1 downto 0);
         pc_in        : in  std_logic_vector(ADDR_SIZE-1 downto 0);
         data_out     : out std_logic_vector(INSTR_SIZE-1 downto 0)
        );
end entity ram_and_pc;

architecture bhv of ram_and_pc is
signal addr_s : std_logic_vector(ADDR_SIZE-1 downto 0) := (others => '0');
    -- Components declaration
    component program_counter is
        generic(SIZE : natural := 16);
        port(clk_in       : in  std_logic;
             pc_operation : in  std_logic_vector(1 downto 0);
             pc_in        : in  std_logic_vector(SIZE-1 downto 0);
             pc_value_out : out std_logic_vector(SIZE-1 downto 0)
            );
    end component;
    component ram_memory_filled is
        generic(MEM_SIZE   : natural := 8;
                INSTR_SIZE : natural := 16);
        port(clk      : in  std_logic;
             wr_en    : in  std_logic;
             addr_in  : in  std_logic_vector(MEM_SIZE-1 downto 0);
             data_in  : in  std_logic_vector(INSTR_SIZE-1 downto 0);
             data_out : out std_logic_vector(INSTR_SIZE-1 downto 0)
            );
    end component;
    begin
    -- Components mapping
    pc_uut:program_counter generic map(SIZE => ADDR_SIZE)
    port map(clk_in       => clk_in,
             pc_operation => pc_operation,
             pc_in        => pc_in,
             pc_value_out => addr_s);
    ram_uut:ram_memory_filled generic map(MEM_SIZE   => 16,
                                   INSTR_SIZE => 16)
    port map(clk      => clk_in,
             wr_en    => '0', -- Read-only, it's a ROM !
             addr_in  => addr_s,
             data_in  => (others => '0'), -- No need to insert data in a ROM :)
             data_out => data_out
            );
end bhv;