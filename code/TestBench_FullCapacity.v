

module TestBench3();

reg car_entered, is_uni_car_entered,car_exited,is_uni_car_exited,clk, enable,enable_cnt, reset_cnt;
wire [9:0] uni_parked_cars, parked_cars, uni_vacated_space, vacated_space;
wire uni_is_vacated_space, is_vacated_space;
wire no_car_error; 
wire uni_capacity_error;
wire capacity_error;
wire [4:0] h;
wire [6:0] m;
wire [6:0] d;

reg enter_car,exit_car;
parking parking
(
    car_entered, is_uni_car_entered,car_exited,is_uni_car_exited,
    clk, enable, enable_cnt, reset_cnt,
    h,m,d,
    uni_parked_cars, parked_cars, uni_vacated_space, vacated_space,
    uni_is_vacated_space, is_vacated_space,
    no_car_error, 
    uni_capacity_error,
    capacity_error
);


always 
    #5 clk <= ~clk;

initial begin
    enable = 0;
    enable_cnt = 1;
    clk = 0;
    reset_cnt = 1;
    #1
    reset_cnt = 0;
    car_entered = 0;
    car_exited = 0;
   forever begin
        if(h >= 8 ) begin
            enable = 1;
            forever    begin
                car_entered = ((h) >= 8 ) ? 1 : 0;
                car_exited = ((h) > 14 && m > 40) ? 1 : 0;
                is_uni_car_entered = (h >= 8 &&( h<=14  && m<=40)) ? 1 : 0;
                is_uni_car_exited = ((h) > 14 && m > 40) ? 1 : 0;
                #1
                car_entered = 0;
                car_exited = 0;
                
                $display("%02d:%02d",h,m);
                $display("uni parked cars :%d - parked cars:%d - uni vacated space :%d - vacated space : %d"
                ,uni_parked_cars,parked_cars , uni_vacated_space, vacated_space);
                
                if(capacity_error == 1) begin
                    $display("ERROR : The new capacity is less than the cars which are already parked");
                end
                if(uni_capacity_error == 1) begin
                    $display("ERROR : The new capacity for university cars is less than the cars which are already parked");
                end
                if(no_car_error == 1) begin
                    $display("ERROR : There is no car, but the signal shows one car wants to exit!");
                end
                
                $display("|uni is vacated : %d | is vacated : %d |",
                uni_is_vacated_space,is_vacated_space);
                #9;
                
                
            end
        end
        else begin
            #10 ;
        
        end
        
    end
end
endmodule
