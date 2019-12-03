library verilog;
use verilog.vl_types.all;
entity forwarding is
    port(
        en              : in     vl_logic;
        rs_ex           : in     vl_logic_vector(4 downto 0);
        rt_ex           : in     vl_logic_vector(4 downto 0);
        writereg_mem    : in     vl_logic_vector(4 downto 0);
        writereg_wb     : in     vl_logic_vector(4 downto 0);
        wb_control_mem  : in     vl_logic_vector(1 downto 0);
        wb_control_wb   : in     vl_logic_vector(1 downto 0);
        fw_control_srca : out    vl_logic_vector(1 downto 0);
        fw_control_srcb : out    vl_logic_vector(1 downto 0)
    );
end forwarding;
