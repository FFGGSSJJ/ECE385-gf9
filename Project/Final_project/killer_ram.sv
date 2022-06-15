module killer (
    input Clk, 
    input Reset,
    input logic killer_exist,
    input logic visited,
    input logic [9:0] DrawX, DrawY,       // Current pixel coordinates
    input logic [2:0][9:0] mov_x, mov_y,
    output logic [19:0][9:0] killer_x,            // x coordinate of killer
	output logic [19:0][9:0] killer_y,            // y coordinate of killer
    output logic [2:0] killer_data,   // index of background color
    output logic is_visiable,
    output logic visit_remain,
	output logic is_killer
);
    // screen size
    parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] killer_WIDTH =  10'd30;
    parameter [9:0] killer_LENGTH = 10'd30;

    parameter [9:0] CENTERX =  10'd15;  // center of the killer
	parameter [9:0] CENTERY =  10'd15;
    parameter [9:0] CORNERX =  10'd0;   // left up corner of the killer
	parameter [9:0] CORNERY =  10'd0;

    // designed coordinates for killer
    parameter [9:0] KILLER_X0 = 10'd105;
    parameter [9:0] KILLER_Y0 = 10'd115;
    
    //move
    parameter [9:0] KILLER_X1 = 10'd135;
    parameter [9:0] KILLER_Y1 = 10'd465;
    parameter [9:0] KILLER_X2 = 10'd165;
    parameter [9:0] KILLER_Y2 = 10'd465;
    parameter [9:0] KILLER_X3 = 10'd195;
    parameter [9:0] KILLER_Y3 = 10'd465;

    parameter [9:0] KILLER_X4 = 10'd255;
    parameter [9:0] KILLER_Y4 = 10'd465;//up

    //static
    parameter [9:0] KILLER_X5 = 10'd300;
    parameter [9:0] KILLER_Y5 = 10'd75;
    parameter [9:0] KILLER_X6 = 10'd300;
    parameter [9:0] KILLER_Y6 = 10'd105;
    parameter [9:0] KILLER_X7 = 10'd300;
    parameter [9:0] KILLER_Y7 = 10'd135;//right

    parameter [9:0] KILLER_X8 = 10'd465;
    parameter [9:0] KILLER_Y8 = 10'd225;//up

    parameter [9:0] KILLER_X9 = 10'd595;
    parameter [9:0] KILLER_Y9 = 10'd195; //left

    parameter [9:0] KILLER_X10 = 10'd495;
    parameter [9:0] KILLER_Y10 = 10'd85;//up

    parameter [9:0] KILLER_X11 = 10'd435;
    parameter [9:0] KILLER_Y11 = 10'd145;//left

    parameter [9:0] KILLER_X12 = 10'd555;
    parameter [9:0] KILLER_Y12 = 10'd115;//up
    parameter [9:0] KILLER_X13 = 10'd555;
    parameter [9:0] KILLER_Y13 = 10'd145;//down
    parameter [9:0] KILLER_X14 = 10'd585;
    parameter [9:0] KILLER_Y14 = 10'd115;//up
    parameter [9:0] KILLER_X15 = 10'd585;
    parameter [9:0] KILLER_Y15 = 10'd145;//down

    //flash
    parameter [9:0] KILLER_X16 = 10'd465;
    parameter [9:0] KILLER_Y16 = 10'd315;
    parameter [9:0] KILLER_X17 = 10'd495;
    parameter [9:0] KILLER_Y17 = 10'd315;//down

    parameter [9:0] KILLER_X18 = 10'd465;
    parameter [9:0] KILLER_Y18 = 10'd345;
    parameter [9:0] KILLER_X19 = 10'd495;
    parameter [9:0] KILLER_Y19 = 10'd345;//up

    //parameter [9:0] KILLER_X20 = 10'd;
    //parameter [9:0] KILLER_Y20 = 10'd;





    
    logic [18:0] read_address;
    logic [9:0] current_x, current_y;
    logic [2:0] killer_u_data, killer_d_data, killer_l_data, killer_r_data;
    logic [2:0][9:0] bound_x, bound_y;
    logic up, down, right, left;
    //logic visit_remain;
    assign read_address = CENTERX-(current_x - DrawX) + (CENTERY-(current_y - DrawY))*killer_LENGTH;
    assign killer_x = '{KILLER_X0, KILLER_X1, KILLER_X2, KILLER_X3, KILLER_X4, KILLER_X5, KILLER_X6, KILLER_X7, KILLER_X8, KILLER_X9, KILLER_X10,
                        KILLER_X11, KILLER_X12, KILLER_X13, KILLER_X14, KILLER_X15, KILLER_X16, KILLER_X17, KILLER_X18, KILLER_X19};
    assign killer_y = '{KILLER_Y0, KILLER_Y1, KILLER_Y2, KILLER_Y3, KILLER_Y4, KILLER_Y5, KILLER_Y6, KILLER_Y7, KILLER_Y8, KILLER_Y9, KILLER_Y10,
                        KILLER_Y11, KILLER_Y12, KILLER_Y13, KILLER_Y14, KILLER_Y15, KILLER_Y16, KILLER_Y17, KILLER_Y18, KILLER_Y19};
    assign bound_x = '{10'd15, 10'd15, 10'd15};
    assign bound_y = '{10'd115, 10'd85, 10'd55};
    KILLER_ROM KILLER_ROM(.*);
    KILLER_D_ROM KILLER_D_ROM(.*);
    KILLER_R_ROM KILLER_R_ROM(.*);
    KILLER_L_ROM KILLER_L_ROM(.*);

    always_ff @( posedge Clk ) begin
        if (Reset)  visit_remain <= 1'b0;
        else if (visited)   visit_remain <= 1'b1;
        else                visit_remain <= visit_remain;
    end

    always_comb 
    begin
		is_killer = 1'b0;
        is_visiable = 1'b0;
        current_x = DrawX;
        current_y = DrawY;
        up = 1'b0;
		down = 1'b0;
		right = 1'b0;
		left = 1'b0;
        for (int i = 0; i < 20; i += 1) begin
            if (killer_exist == 1'b1 && 
                DrawX >= killer_x[i] - (CENTERX - CORNERX) && DrawX < killer_x[i] + CENTERX &&
                DrawY >= killer_y[i] - (CENTERY - CORNERY) && DrawY < killer_y[i] + CENTERY ) begin
                    if (i < 4 && visited == 1'b0 && visit_remain == 1'b0) is_visiable = 1'b0;
                    if ((i < 4 && visited == 1'b1) || visit_remain == 1'b1) is_visiable = 1'b1;
                    if (i >= 4)  is_visiable = 1'b1;
                    if (i <= 1 || i == 5 || i == 7 || i == 9 || i == 11 || i >= 15)     up = 1'b1;
                    else if (i == 2 || i == 3 || i == 4 || i == 6)  down = 1'b1;
                    else if (i == 12 || i == 13 || i == 14) right = 1'b1;
                    else    left = 1'b1;
                    is_killer = 1'b1;
                    current_x = killer_x[i];
                    current_y = killer_y[i];
            end
        end

        for (int i = 0; i < 3; i += 1) begin
            if (killer_exist == 1'b1 && 
                DrawX >= mov_x[i] - (CENTERX - CORNERX) && DrawX < mov_x[i] + CENTERX &&
                DrawY >= mov_y[i] - (CENTERY - CORNERY) && DrawY < mov_y[i] + CENTERY ) begin
                    is_visiable = 1'b1;
                    up = 1'b1;
                    is_killer = 1'b1;
                    current_x = mov_x[i];
                    current_y = mov_y[i];
            end
        end

        for (int i = 0; i < 3; i += 1) begin
            if (killer_exist == 1'b1 && 
                DrawX >= bound_x[i] - (CENTERX - CORNERX) && DrawX < bound_x[i] + CENTERX &&
                DrawY >= bound_y[i] - (CENTERY - CORNERY) && DrawY < bound_y[i] + CENTERY ) begin
                    is_visiable = 1'b1;
                    right = 1'b1;
                    is_killer = 1'b1;
                    current_x = bound_x[i];
                    current_y = bound_y[i];
            end
        end

        if (up)         killer_data = killer_u_data;
        else if (down)  killer_data = killer_d_data;
        else if (right) killer_data = killer_r_data;
        else            killer_data = killer_l_data;
		
	end
endmodule


module  KILLER_ROM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] killer_u_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [2:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/killer.txt", mem);
end


always_ff @ (posedge Clk) begin
	killer_u_data<= mem[read_address];
end

endmodule


module  KILLER_D_ROM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] killer_d_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [2:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/killer_d.txt", mem);
end


always_ff @ (posedge Clk) begin
	killer_d_data<= mem[read_address];
end

endmodule



module  KILLER_R_ROM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] killer_r_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [2:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/killer_r.txt", mem);
end


always_ff @ (posedge Clk) begin
	killer_r_data<= mem[read_address];
end

endmodule


module  KILLER_L_ROM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] killer_l_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [2:0] mem [0:899];
initial
begin
	 $readmemh("sprite_hex/killer_l.txt", mem);
end


always_ff @ (posedge Clk) begin
	killer_l_data<= mem[read_address];
end

endmodule