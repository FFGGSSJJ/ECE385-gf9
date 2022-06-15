//8-bit multiplexer top level module
//for use with ECE 385 Fall 2016
//last modified by Guanshujie Fu


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement
module processor (
    input logic Clk, Reset, Run, ClearA_LoadB, 
    input logic [7:0] S, 

    output logic [7:0] Aval, Bval,
    output logic X,        // sign bit
    output logic [6:0] AhexL, AhexU, BhexL, BhexU
);
    // local variables
    logic Reset_SH, ClrA_LdB_SH, Run_SH;
    logic [8:0] Partial_sum;
    logic [7:0] A, B, S_SH;
    logic Sign, Sub, Add, ClA_LdB, last_A, last_B, Shift, ClA_KeB;
    //
    assign Aval = A;
	assign Bval = B;
    assign M = last_B;
    assign X = Sign;
	 

    // module instantiation
    register_unit reg_unit(
        .Clk(Clk),
        .Reset(Reset_SH),
        .A_In(Sign),
        .B_In(last_A),
        .ClearA_LoadB(ClA_LdB), // the ClearA_LoadB will execute only once for each run
        .ADD(Add),
        .Shift_En(Shift),
		  .ClearA_KeepB(ClA_KeB),
        .D_A(Partial_sum[7:0]),
        .D_B(S),
        // output
        .A_out(last_A),
        .B_out(last_B), 
        .A(A),
        .B(B)
    );

    control control_unit(
        .Clk(Clk), 
        .Reset(Reset_SH), 
        .Run(Run_SH), 
        .ClearXA_LoadB(ClrA_LdB_SH), 
        .M(M),   // the last bit of B
        // output
        .Shift_XAB(Shift),
        .ADD(Add), 
        .SUB(Sub), 
        .ClrA_LdB(ClA_LdB),
		  .ClearA_KeepB(ClA_KeB)
    );

    add_sub9 add_sub_unit(
        .A(A), 
        .B(S),
        .fn(Sub),
		  .M(M),
        // output
        .S(Partial_sum)
    );

    X_reg x_reg(
        .Clk(Clk), 
        .Load(Add), 
        .Reset(Reset_SH | ClA_LdB), 
        .D(Partial_sum[8]),     // the sign bit
        // output
        .Q(Sign)
    );

    HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
	HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );	
	HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );
    sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClrA_LdB_SH, Run_SH});
    sync Din_sync[7:0]    (Clk, S, S_SH);
    
endmodule