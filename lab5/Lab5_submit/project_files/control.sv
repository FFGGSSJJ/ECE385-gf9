module control (
    input logic Clk, Reset, Run, ClearXA_LoadB, M, 
    output logic Shift_XAB, ADD, SUB, ClrA_LdB, ClearA_KeepB
);
    // Declare the states as current and next state.
    // there will have 2*8+1 = 17 states for 8-bit multiplication. 
    enum logic [4:0] {S, Q, A1, A2, B1, B2, C1, C2, D1, D2, E1, E2, F1, F2, G1, G2, H1, H2, I} curr_state, next_state;
    
    //updates flip flop, current state change
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= S;
        else 
            curr_state <= next_state;
    end

    // assign outputs based on current state
    always_comb 
    begin
        next_state = curr_state;
        unique case (curr_state)
            S:  if (Run)
                    next_state = Q;
				Q : next_state = A1;
            A1: next_state = A2;
            A2: next_state = B1;
            B1: next_state = B2;
            B2: next_state = C1;
            C1: next_state = C2;
            C2: next_state = D1;
            D1: next_state = D2;
            D2: next_state = E1;
            E1: next_state = E2;
            E2: next_state = F1;
            F1: next_state = F2;
            F2: next_state = G1;
            G1: next_state = G2;
            G2: next_state = H1;
            H1: next_state = H2;
            H2: next_state = I;
            I:  if (~Run)
                    next_state = S; 
        endcase
        

        case (curr_state)
            S:
                begin
                    SUB = 0; ADD = 0;
                    ClrA_LdB = ClearXA_LoadB;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
				Q:
					 begin
						  SUB = 0; ADD = 0;
						  Shift_XAB = 0;
						  ClrA_LdB = 0;
						  ClearA_KeepB = 1;
					 end
            A1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            B1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            C1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            D1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            E1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            F1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            G1: 
                begin
                    SUB = 0; ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            H1: 
                begin
                    if (M == 1) SUB = 1;
                    else        SUB = 0;
                    ADD = 1;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            I:
                begin
                    SUB = 0; ADD = 0;
                    ClrA_LdB = 0;
                    Shift_XAB = 0;
						  ClearA_KeepB = 0;
                end
            default: 
                begin
                    SUB = 0; ADD = 0;
                    Shift_XAB = 1;
                    ClrA_LdB = 0;
						  ClearA_KeepB = 0;
                end
        endcase
    end



endmodule