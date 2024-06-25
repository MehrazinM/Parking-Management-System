library verilog;
use verilog.vl_types.all;
entity parking_s is
    generic(
        MAX_UNI_CAPACITY: integer := 500;
        MAX_OTHER_CAPACITY: integer := 200;
        rate            : integer := 50
    );
    port(
        car_entered     : in     vl_logic;
        is_uni_car_entered: in     vl_logic;
        car_exited      : in     vl_logic;
        is_uni_car_exited: in     vl_logic;
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        enable_cnt      : in     vl_logic;
        reset_cnt       : in     vl_logic;
        h               : out    vl_logic_vector(4 downto 0);
        m               : out    vl_logic_vector(6 downto 0);
        d               : out    vl_logic_vector(6 downto 0);
        uni_parked_cars : out    vl_logic_vector(9 downto 0);
        parked_cars     : out    vl_logic_vector(9 downto 0);
        uni_vacated_space: out    vl_logic_vector(9 downto 0);
        vacated_space   : out    vl_logic_vector(9 downto 0);
        uni_is_vacated_space: out    vl_logic;
        is_vacated_space: out    vl_logic;
        no_car_error    : out    vl_logic;
        uni_capacity_error: out    vl_logic;
        capacity_error  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MAX_UNI_CAPACITY : constant is 1;
    attribute mti_svvh_generic_type of MAX_OTHER_CAPACITY : constant is 1;
    attribute mti_svvh_generic_type of rate : constant is 1;
end parking_s;
