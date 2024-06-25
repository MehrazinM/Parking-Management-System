module tb_counter();
reg clk, enable , reset;
wire [4:0] hour;
wire [6:0] minute;
wire [6:0] day;
clock_counter clock_counter (
     clk, enable, reset,
     hour,
     minute,
     day
);

always 
 #5 clk <= ~clk;
initial begin
    reset = 1;
    clk = 0;
    #10
    reset = 0;
    clk = 0;
    enable = 1;

end
always @( *) begin
    $display($time, "%d (day) %d:%d",day,  hour, minute);
end

endmodule
