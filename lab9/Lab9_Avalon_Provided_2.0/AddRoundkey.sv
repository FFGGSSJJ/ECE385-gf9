module AddRoundKey (
    input logic [127:0] state, 
    input logic [127:0] roundkey, 
    output logic [127:0] outkey
);
    assign outkey = state ^ roundkey;
    
endmodule