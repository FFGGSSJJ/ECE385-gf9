module register_unit (input  logic Clk, Reset, A_In, B_In, ClearA_LoadB, ADD, 
                            Shift_En, ClearA_KeepB, 
                      input  logic [7:0]  D_A, 
                      input  logic [7:0]  D_B,
                      output logic A_out, B_out, 
                      output logic [7:0]  A,
                      output logic [7:0]  B);

    // for register A, it will load 0 when 
    reg_8  reg_A (.*, .Reset(Reset | ClearA_KeepB), .D(D_A), .Shift_In(A_In), .Load(ADD),
	               .Shift_Out(A_out), .Data_Out(A));
    reg_8  reg_B (.*, .D(D_B), .Shift_In(B_In), .Load(ClearA_LoadB),
	               .Shift_Out(B_out), .Data_Out(B));

endmodule