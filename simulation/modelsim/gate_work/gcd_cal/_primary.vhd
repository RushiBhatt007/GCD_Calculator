library verilog;
use verilog.vl_types.all;
entity gcd_cal is
    port(
        IN1             : in     vl_logic_vector(3 downto 0);
        IN2             : in     vl_logic_vector(3 downto 0);
        C               : out    vl_logic_vector(3 downto 0)
    );
end gcd_cal;
