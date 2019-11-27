library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        id_control_idin : in     vl_logic;
        ex_control_idin : in     vl_logic_vector(10 downto 0);
        mem_control_idin: in     vl_logic;
        wb_control_idin : in     vl_logic_vector(1 downto 0);
        alucontrol_exin : in     vl_logic_vector(3 downto 0);
        instr_ifin      : in     vl_logic_vector(31 downto 0);
        op_idout        : out    vl_logic_vector(5 downto 0);
        jumptemp_exout  : out    vl_logic_vector(1 downto 0);
        funct_exout     : out    vl_logic_vector(5 downto 0);
        aluop_exout     : out    vl_logic_vector(1 downto 0);
        jump_exin       : in     vl_logic_vector(1 downto 0);
        pc              : out    vl_logic_vector(31 downto 0);
        aluout          : out    vl_logic_vector(31 downto 0);
        writedata       : out    vl_logic_vector(31 downto 0);
        memwrite        : out    vl_logic;
        readdata        : in     vl_logic_vector(31 downto 0)
    );
end datapath;
