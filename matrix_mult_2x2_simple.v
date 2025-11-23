// Simple 2x2 matrix multiplier without MAC - direct implementation
module matrix_mult_2x2_simple(
    input clk,
    input rst,
    input start,
    input [15:0] a00, a01, a10, a11,
    input [15:0] b00, b01, b10, b11,
    output reg [31:0] c00, c01, c10, c11,
    output reg done,
    output reg busy
);

    reg [2:0] state;
    
    // Direct computation wires for each element
    wire [31:0] c00_calc, c01_calc, c10_calc, c11_calc;
    
    // Calculate each element directly
    assign c00_calc = (a00 * b00) + (a01 * b10); // C[0][0] = A[0][0]*B[0][0] + A[0][1]*B[1][0]
    assign c01_calc = (a00 * b01) + (a01 * b11); // C[0][1] = A[0][0]*B[0][1] + A[0][1]*B[1][1]
    assign c10_calc = (a10 * b00) + (a11 * b10); // C[1][0] = A[1][0]*B[0][0] + A[1][1]*B[1][0]
    assign c11_calc = (a10 * b01) + (a11 * b11); // C[1][1] = A[1][0]*B[0][1] + A[1][1]*B[1][1]

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'd0;
            done <= 1'b0;
            busy <= 1'b0;
            c00 <= 32'b0;
            c01 <= 32'b0;
            c10 <= 32'b0;
            c11 <= 32'b0;
        end else begin
            case (state)
                3'd0: begin // IDLE
                    if (start) begin
                        busy <= 1'b1;
                        done <= 1'b0;
                        state <= 3'd1;
                    end
                end
                
                3'd1: begin // COMPUTE (wait one cycle for combinational logic to settle)
                    state <= 3'd2;
                end
                
                3'd2: begin // CAPTURE RESULTS
                    c00 <= c00_calc;
                    c01 <= c01_calc;
                    c10 <= c10_calc;
                    c11 <= c11_calc;
                    state <= 3'd3;
                end
                
                3'd3: begin // DONE
                    done <= 1'b1;
                    busy <= 1'b0;
                    if (!start) begin
                        state <= 3'd0;
                    end
                end
                
                default: begin
                    state <= 3'd0;
                end
            endcase
        end
    end

endmodule