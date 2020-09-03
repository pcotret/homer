-- Libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.homer_pack.all;
use work.homer_constants.all;

-- Entity
entity homer is 
generic(INSTR_SIZE : natural := 16; -- Instruction size
        SIZE       : natural := 16; -- Adress width
        REG_NB     : natural := 4;  -- log2 number of registers. Dependency with adress width
        REG_SIZE   : natural := 16  -- Size of a single register 
       );
port(clk_in         : in  std_logic;
     instruction_in : in  std_logic_vector(INSTR_SIZE-1 downto 0);
     addr_out       : out std_logic_vector(SIZE-1 downto 0)
    );
end entity homer;

-- Architecture
architecture bhv of homer is
-- Signals declaration
signal pc_value_s  : std_logic_vector(SIZE-1 downto 0);
signal read_data_s : std_logic_vector(INSTR_SIZE-1 downto 0);
signal reg_src1_s  : std_logic_vector(REG_NB-1 downto 0);
signal reg_src2_s  : std_logic_vector(REG_NB-1 downto 0);
signal reg_dst_s   : std_logic_vector(REG_NB-1 downto 0);
signal imm_s       : std_logic_vector(REG_SIZE-1 downto 0);
signal wr_en_s     : std_logic;
signal opcode_s    : std_logic_vector(3 downto 0);
signal src1_reg_s  : std_logic_vector(REG_SIZE-1 downto 0);
signal src2_reg_s  : std_logic_vector(REG_SIZE-1 downto 0);
signal dst_reg_s   : std_logic_vector(REG_SIZE-1 downto 0);
signal state_s     : std_logic_vector(3 downto 0);
signal state_xor_s : std_logic;
signal pcop_s      : std_logic_vector(1 downto 0);

-- Components declaration
component alu is
    generic(REG_WIDTH : natural := 16;
            SIZE      : natural := 4);
    port(clk          : in  std_logic;
         en           : in  std_logic;
         opcode_in    : in  std_logic_vector(3 downto 0);
         src1_reg_in  : in  std_logic_vector(REG_WIDTH-1 downto 0);
         src2_reg_in  : in  std_logic_vector(REG_WIDTH-1 downto 0);
         dst_reg_out  : out std_logic_vector(REG_WIDTH-1 downto 0)
        );
end component alu;
component homer_fsm is
    port(clk_in    : in  std_logic;
         reset_in  : in  std_logic;
         state_out : out std_logic_vector(3 downto 0)
        );
end component homer_fsm;
component instruction_decoder is
    generic(INSTR_SIZE : natural := 16;
            REG_NB     : natural := 4;
            REG_SIZE   : natural := 16);
    port(clk      : in  std_logic;
         en       : in  std_logic;
         instr_in : in  std_logic_vector(INSTR_SIZE-1 downto 0);
         reg_src1 : out std_logic_vector(REG_NB-1 downto 0);
         reg_src2 : out std_logic_vector(REG_NB-1 downto 0);
         reg_dst  : out std_logic_vector(REG_NB-1 downto 0);
         imm      : out std_logic_vector(REG_SIZE-1 downto 0);
         wr_en    : out std_logic;
         opcode   : out std_logic_vector(3 downto 0)
        );
end component instruction_decoder;
component program_counter is
    generic(SIZE : natural := 16);
    port(clk_in       : in  std_logic;
         pc_operation : in  std_logic_vector(1 downto 0);
         pc_value_out : out std_logic_vector(SIZE-1 downto 0)
        );
end component program_counter;
component reg_file is
    generic(REG_WIDTH : natural := 16;
            SIZE      : natural := 4);
    port(clk          : in  std_logic;
         en           : in  std_logic;
         wr_en        : in  std_logic;
         src1_sel_in  : in  std_logic_vector(SIZE-1 downto 0);
         src1_reg_out : out std_logic_vector(REG_WIDTH-1 downto 0);
         src2_sel_in  : in  std_logic_vector(SIZE-1 downto 0);
         src2_reg_out : out std_logic_vector(REG_WIDTH-1 downto 0);
         dst_sel_in   : in  std_logic_vector(SIZE-1 downto 0);
         dst_reg_in   : in  std_logic_vector(REG_WIDTH-1 downto 0)
        );
end component reg_file;
-- Components mapping
begin
uut_alu:alu
generic map(REG_WIDTH => REG_SIZE,
            SIZE      => SIZE)
port map(clk         => clk_in,
         en          => state_s(2),
         opcode_in   => opcode_s,
         src1_reg_in => src1_reg_s,
         src2_reg_in => src2_reg_s,
         dst_reg_out => dst_reg_s
        );
        pcop_s <= PC_INC when state_s(2) = '1' else
                  PC_NOP;
uut_pc:program_counter
generic map(SIZE => SIZE)
port map(clk_in       => clk_in,
         pc_operation => pcop_s,
         pc_value_out => pc_value_s 
        );
        addr_out <= pc_value_s;
uut_inst:instruction_decoder
generic map(INSTR_SIZE => INSTR_SIZE,
            REG_NB     => REG_NB,
            REG_SIZE   => REG_SIZE
           )
port map(clk      => clk_in,
         en       => state_s(0),
         instr_in => instruction_in,
         reg_src1 => reg_src1_s,
         reg_src2 => reg_src2_s,
         reg_dst  => reg_dst_s,
         imm      => imm_s,
         wr_en    => wr_en_s,
         opcode   => opcode_s
        );
        state_xor_s<=state_s(1) or state_s(3);
uut_reg:reg_file
generic map(REG_WIDTH => REG_SIZE,
            SIZE      => REG_NB
           )
port map(clk          => clk_in,
         en           => state_xor_s,
         wr_en        => wr_en_s,
         src1_sel_in  => reg_src1_s,
         src1_reg_out => src1_reg_s,
         src2_sel_in  => reg_src2_s,
         src2_reg_out => src2_reg_s,
         dst_sel_in   => reg_dst_s,
         dst_reg_in   => dst_reg_s
        );
uut_fsm:homer_fsm
port map(clk_in    => clk_in,
         reset_in  => '0',
         state_out => state_s
        );
end architecture bhv;
