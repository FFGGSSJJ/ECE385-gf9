module reg_file (
    input logic Clk, Reset, 
    input logic Load, 
    input logic [2:0] DRMUX, SR1, SR2, 
    input logic [15:0] Bus_in,

    output logic [15:0] SR1_out, SR2_out
);
    logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

    always_ff @( posedge Clk) begin
        if (Load) begin
            case (DRMUX)
                3'b000: R0 <= Bus_in;
                3'b001: R1 <= Bus_in; 
                3'b010: R2 <= Bus_in; 
                3'b011: R3 <= Bus_in; 
                3'b100: R4 <= Bus_in; 
                3'b101: R5 <= Bus_in; 
                3'b110: R6 <= Bus_in; 
                default:R7 <= Bus_in; 
            endcase
        end
		  if (~Reset) begin
            R0 <= 16'b0;
            R1 <= 16'b0;
            R2 <= 16'b0;
            R3 <= 16'b0;
            R4 <= 16'b0;
            R5 <= 16'b0;
            R6 <= 16'b0;
            R7 <= 16'b0;
        end
    end

    always_comb begin
        case (SR1)
            3'b000: SR1_out = R0;
            3'b001: SR1_out = R1;
            3'b010: SR1_out = R2;
            3'b011: SR1_out = R3;
            3'b100: SR1_out = R4;
            3'b101: SR1_out = R5;
            3'b110: SR1_out = R6;
            default:SR1_out = R7;
        endcase

        case (SR2)
            3'b000: SR2_out = R0;
            3'b001: SR2_out = R1;
            3'b010: SR2_out = R2;
            3'b011: SR2_out = R3;
            3'b100: SR2_out = R4;
            3'b101: SR2_out = R5;
            3'b110: SR2_out = R6;
            default:SR2_out = R7;
        endcase
    end


endmodule