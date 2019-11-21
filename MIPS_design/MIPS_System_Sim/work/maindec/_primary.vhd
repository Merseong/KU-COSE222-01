library verilog;
use verilog.vl_types.all;
entity maindec is
    port(
        op              : in     vl_logic_vector(5 downto 0);
        id_control      : out    vl_logic;
        ex_control      : out    vl_logic_vector(6 downto 0);
        mem_control     : out    vl_logic_vector(2 downto 0);
        wb_control      : out    vl_logic_vector(1 downto 0);
        jump            : out    vl_logic_vector(1 downto 0)
    );
end maindec;
