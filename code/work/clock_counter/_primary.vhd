library verilog;
use verilog.vl_types.all;
entity clock_counter is
    port(
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        reset           : in     vl_logic;
        hour            : out    vl_logic_vector(4 downto 0);
        minute          : out    vl_logic_vector(6 downto 0);
        day             : out    vl_logic_vector(6 downto 0)
    );
end clock_counter;
