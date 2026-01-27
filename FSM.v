module FSM (
    input  wire clk,
    input  wire reset,     // Asynchronous active-high reset
    input  wire input_bit, // Example input
    output reg  output_sig // Example output
);

    // 1. State Encoding (Localparam or Typedef)
    // Using 3 bits to represent 7 states (2^3 = 8)
    localparam STATE_A = 3'd0,
               STATE_B = 3'd1,
               STATE_C = 3'd2,
               STATE_D = 3'd3,
               STATE_E = 3'd4,
               STATE_F = 3'd5,
               STATE_G = 3'd6;

    reg [2:0] current_state, next_state;

    // 2. Sequential Logic: State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= STATE_A; // Default reset state
        else
            current_state <= next_state;
    end

    // 3. Combinational Logic: Next State Logic
    always @(*) begin
        case (current_state)
            STATE_A: next_state = (input_bit) ? STATE_B : STATE_A;
            STATE_B: next_state = (input_bit) ? STATE_C : STATE_A;
            STATE_C: next_state = (input_bit) ? STATE_D : STATE_B;
            STATE_D: next_state = (input_bit) ? STATE_E : STATE_C;
            STATE_E: next_state = (input_bit) ? STATE_F : STATE_D;
            STATE_F: next_state = (input_bit) ? STATE_G : STATE_E;
            STATE_G: next_state = (input_bit) ? STATE_A : STATE_F;
            default: next_state = STATE_A;
        endcase
    end

    // 4. Combinational Logic: Output Logic (Mealy or Moore)
    // This example is a Moore Machine (output depends only on state)
    always @(*) begin
        case (current_state)
            STATE_G: output_sig = 1'b1; // Output high only in the last state
            default: output_sig = 1'b0;
        endcase
    end

endmodule
