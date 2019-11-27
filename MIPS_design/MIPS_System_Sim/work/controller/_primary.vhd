library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        op_id           : in     vl_logic_vector(5 downto 0);
        funct_ex        : in     vl_logic_vector(5 downto 0);
        aluop_ex        : in     vl_logic_vector(1 downto 0);
        jumptemp_ex     : in     vl_logic_vector(1 downto 0);
        jump_ex         : out    vl_logic_vector(1 downto 0);
        id_control      : out    vl_logic;
        ex_control      : out    vl_logic_vector(10 downto 0);
        mem_control     : out    vl_logic;
        wb_control      : out    vl_logic_vector(1 downto 0);
        alucontrol      : out    vl_logic_vector(3 downto 0)
    );
end controller;
