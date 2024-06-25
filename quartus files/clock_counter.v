module clock_counter (
    input clk, enable, reset,
    output [4:0] hour,
    output [6:0] minute,
    output [6:0] day
    
);
reg [4:0] h;
reg[6:0] m;
reg[6:0] d;
assign hour = h;
assign minute = m;
assign day = d;
always@(posedge clk) begin
    if(reset) begin
        h = 0;
        m = 0;
        d = 0;
    end
    else begin
        if(enable)begin
            if (m == 59) begin
                m = 0;
                if( h == 23) begin
                    h = 0;
                    d = d + 1;
                end
                else begin
                    h = h + 1;
                end
            end        
            else
                 m = m + 1;
        end
        else begin
            h = 'bz;
            m = 'bz;
            d = 'bz;
        end   
    end

        

end

    
endmodule
