module parking_s
#(parameter MAX_UNI_CAPACITY = 500, parameter MAX_OTHER_CAPACITY = 200, parameter rate = 50)
(
    input car_entered, is_uni_car_entered,car_exited,is_uni_car_exited,
    clk, enable, enable_cnt, reset_cnt,
    output [4:0] h,
	 output [6:0] m,
     output [6:0] d,
    output reg [9:0] uni_parked_cars =0,
    output reg [9:0] parked_cars = 0,
    output reg [9:0]  uni_vacated_space = MAX_UNI_CAPACITY,
    output reg [9:0] vacated_space = MAX_OTHER_CAPACITY,
    output wire uni_is_vacated_space, is_vacated_space,
    output reg no_car_error = 0, 
    output reg uni_capacity_error = 0,
    output reg capacity_error = 0
);
reg [9:0] uni_cap = MAX_UNI_CAPACITY;
reg [9:0] other_cap = MAX_OTHER_CAPACITY;

wire [4:0] hour;
wire [6:0] minute;
wire [6:0] day;
assign h = hour;
assign m = minute;
assign d = day;
clock_counter clock_counter (
     clk, enable_cnt, reset_cnt,
     hour,
     minute,
     day
);
assign uni_is_vacated_space = uni_vacated_space > 0;
assign is_vacated_space = vacated_space > 0;

//handling car entrances
always @(*) begin
	if(!car_entered)begin
    if(enable)begin
       //define the capacity of each mode
       
       if(hour >= 8 && hour < 13) begin
            uni_vacated_space = uni_cap - uni_parked_cars;
            vacated_space = other_cap - parked_cars;
       end
       else if ( hour >= 13 && hour < 16) begin
            if( (MAX_UNI_CAPACITY - (hour - 12) * rate) <  uni_parked_cars) begin
                uni_capacity_error = 1; //when the capacity reduces, we have more cars than it should be
                uni_vacated_space = 0;
            end
            else begin 
                uni_capacity_error= 0; 
                uni_vacated_space = (MAX_UNI_CAPACITY - (hour - 12) * rate) - uni_parked_cars;
                vacated_space = MAX_OTHER_CAPACITY + (hour - 12) * rate - parked_cars;
            end
       end
       else if(hour >= 16) begin
        if( MAX_OTHER_CAPACITY <  uni_parked_cars) begin
                uni_capacity_error= 1; //when the capacity reduces, we have more cars than it should be
                uni_vacated_space = 0;
        end
        else begin 
                uni_capacity_error= 0; 
                uni_vacated_space = MAX_OTHER_CAPACITY - uni_parked_cars;
                vacated_space = MAX_UNI_CAPACITY - parked_cars;
        end
       end
       if(is_uni_car_entered && uni_vacated_space > 0) begin
        uni_parked_cars = uni_parked_cars + 1;
        uni_vacated_space = uni_vacated_space - 1;
       end
       else if( !is_uni_car_entered && vacated_space > 0 ) begin
        parked_cars = parked_cars + 1;
        vacated_space = vacated_space - 1;
       end


    end
    else begin
        uni_parked_cars = 0;
        parked_cars = 0;
        no_car_error = 0;
        uni_capacity_error = 0;
        capacity_error = 0;
        uni_vacated_space = MAX_UNI_CAPACITY;
        vacated_space = MAX_OTHER_CAPACITY;
    end
	 end


//handling car exits
if (!car_exited) begin
    if(enable)begin
        if(is_uni_car_exited) begin
            if(uni_parked_cars == 0) begin
                no_car_error = 1; //some car wants to exit where there is no car
                vacated_space =0;
            end
            else begin
                no_car_error = 0;
                uni_parked_cars = uni_parked_cars - 1;

            end
        end
        else begin
            if(parked_cars == 0)begin
                no_car_error = 1;
                vacated_space = 0;
            end
            else begin
                no_car_error = 0;
                parked_cars = parked_cars - 1;
            end
        end
        if(hour < 8) begin
            if(parked_cars > MAX_OTHER_CAPACITY) begin
                capacity_error = 1;
                vacated_space = 0;
            end

            else
                capacity_error = 0;
        end
        else if(hour >= 8 && hour < 13) begin
            uni_vacated_space = MAX_UNI_CAPACITY - uni_parked_cars;
            vacated_space = MAX_OTHER_CAPACITY - parked_cars;
        end
        else if( hour >= 13 && hour < 16) begin
            
            if( MAX_UNI_CAPACITY - (hour - 12) * rate <  uni_parked_cars ) begin
                 uni_capacity_error = 1;
                uni_vacated_space = 0;
            end
               
            else begin 
                no_car_error = 0;
                uni_capacity_error = 0;
                uni_vacated_space = MAX_UNI_CAPACITY - (hour - 12) * rate - uni_parked_cars;
                vacated_space = MAX_OTHER_CAPACITY + (hour - 12) * rate - parked_cars;
            end
        end
        else if(hour >= 16) begin
            if( MAX_OTHER_CAPACITY <  uni_parked_cars ) begin
                uni_capacity_error = 1;
                uni_vacated_space = 0;
            end
            else begin 
                    uni_vacated_space = MAX_OTHER_CAPACITY - uni_parked_cars;
                    vacated_space = MAX_UNI_CAPACITY - parked_cars;
            end
        end
        if(hour < 8) begin
        uni_vacated_space = MAX_UNI_CAPACITY - parked_cars;
        if(parked_cars > MAX_OTHER_CAPACITY) begin
            capacity_error = 1;
            vacated_space = 0;
        end
        else begin
            vacated_space = MAX_OTHER_CAPACITY - parked_cars;
            capacity_error = 0;
        end
       end


    end 
    else begin
        uni_parked_cars = 0;
        parked_cars = 0;
        no_car_error = 0;
        uni_capacity_error = 0;
        capacity_error = 0;
        uni_vacated_space = MAX_UNI_CAPACITY;
        vacated_space = MAX_OTHER_CAPACITY;

    end
end
end

endmodule
/* we put else blocks for each if in order to make sure this design is synthesiszble.
when enable = 0 : it means the parking is empty but pay attention we dont need
*/
