module save (
    input Clk, 
    input logic save_exist,
    input logic [9:0] DrawX, DrawY,       // Current pixel coordinates
    input logic [9:0] kid_x, kid_y,         // xy coordinate of kid
    input logic [7:0] keycode,
    output logic [2:0] save_data,   // index of color
	output logic is_save, 
    output logic [1:0] save_s
);
    parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] SAVE_WIDTH =  10'd20;
    parameter [9:0] SAVE_LENGTH = 10'd20;

    parameter [9:0] CENTERX =  10'd10;  // center of the kid
	parameter [9:0] CENTERY =  10'd10;
    parameter [9:0] CORNERX =  10'd0;   // left up corner of the kid
	parameter [9:0] CORNERY =  10'd0;

    logic [18:0] read_address;
    logic [9:0] current_x, current_y;
    logic [1:0][9:0] save_x, save_y;
    logic [2:0] saveo_data, saved_data;
    assign save_x = '{10'd270, 10'd625};
    assign save_y = '{10'd440, 10'd290};
    assign read_address = CENTERX-(current_x - DrawX) + (CENTERY-(current_y - DrawY))*SAVE_LENGTH;
    SAVE_RAM SAVE_RAM(.*);
    SAVED_RAM SAVED_RAM(.*);


    always_comb 
    begin
		is_save = 1'b0;
        save_s = 2'b00;
        current_x = DrawX;
        current_y = DrawY;
        for (int i = 0; i < 2; i++) begin
            if (save_exist == 1'b1 && 
                DrawX >= save_x[i] - (CENTERX - CORNERX) && DrawX <= save_x[i] + CENTERX &&
                DrawY >= save_y[i] - (CENTERY - CORNERY) && DrawY <= save_y[i] + CENTERY ) begin
                    if (((kid_x - save_x[i])*(kid_x - save_x[i]) + (kid_y - save_y[i])*(kid_y - save_y[i])) <= (40*40) && keycode == 8'd22 && i == 0) 
                        save_s = 2'b01;
                    else if (((kid_x - save_x[i])*(kid_x - save_x[i]) + (kid_y - save_y[i])*(kid_y - save_y[i])) <= (40*40) && keycode == 8'd22 && i == 1)
                        save_s = 2'b10;
                    else save_s = 2'b00;

                    is_save = 1'b1;
                    current_x = save_x[i];
                    current_y = save_y[i];
            end
        end	

        if (save_s > 0)   save_data = saved_data;
        else        save_data = saveo_data;

	end
endmodule


module  SAVE_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] saveo_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:399];
initial
begin
	 $readmemh("sprite_hex/save.txt", mem);
end


always_ff @ (posedge Clk) begin
	saveo_data<= mem[read_address];
end

endmodule

module  SAVED_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [2:0] saved_data
);
// mem has width of 4 bits and a total of 307200 addresses

//logic [3:0] mem [0:307199];
logic [3:0] mem [0:399];
initial
begin
	 $readmemh("sprite_hex/saved.txt", mem);
end


always_ff @ (posedge Clk) begin
	saved_data<= mem[read_address];
end

endmodule