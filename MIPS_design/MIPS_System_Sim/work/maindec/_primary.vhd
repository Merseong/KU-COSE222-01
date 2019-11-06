library verilog;
use verilog.vl_types.all;
entity maindec is
    port(
        op              : in     vl_logic_vector(5 downto 0);
        signext         : out    vl_logic;
        shiftl16        : out    vl_logic;
        memtoreg        : out    vl_logic;
        memwrite        : out    vl_logic;
        branch          : out    vl_logic;
        alusrc          : out    vl_logic_vector(1 downto 0);
        regdst          : out    vl_logic_vector(1 downto 0);
        regwrite        : out    vl_logic;
        jump            : out    vl_logic;
        aluop           : out    vl_logic_vector(1 downto 0)
    );
end maindec;
