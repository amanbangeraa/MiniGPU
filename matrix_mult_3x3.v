// 3x3 Matrix Multiplier - Standard Verilog Compatible
module matrix_mult_3x3(
    input clk,
    input rst,
    input start,
    // Matrix A elements
    input [15:0] a00, a01, a02,
    input [15:0] a10, a11, a12,
    input [15:0] a20, a21, a22,
    // Matrix B elements  
    input [15:0] b00, b01, b02,
    input [15:0] b10, b11, b12,
    input [15:0] b20, b21, b22,
    // Matrix C elements (result)
    output reg [31:0] c00, c01, c02,
    output reg [31:0] c10, c11, c12,
    output reg [31:0] c20, c21, c22,
    // Control signals
    output reg done,
    output reg busy
);

    // State machine
    reg [2:0] state;
    
    // States
    localparam IDLE = 3'b000;
    localparam COMPUTE = 3'b001;
    localparam DONE = 3'b010;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            c00 <= 32'h0; c01 <= 32'h0; c02 <= 32'h0;
            c10 <= 32'h0; c11 <= 32'h0; c12 <= 32'h0;
            c20 <= 32'h0; c21 <= 32'h0; c22 <= 32'h0;
            done <= 1'b0;
            busy <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        busy <= 1'b1;
                        state <= COMPUTE;
                    end
                end
                
                COMPUTE: begin
                    // Row 0
                    c00 <= a00*b00 + a01*b10 + a02*b20;
                    c01 <= a00*b01 + a01*b11 + a02*b21;
                    c02 <= a00*b02 + a01*b12 + a02*b22;
                    // Row 1
                    c10 <= a10*b00 + a11*b10 + a12*b20;
                    c11 <= a10*b01 + a11*b11 + a12*b21;
                    c12 <= a10*b02 + a11*b12 + a12*b22;
                    // Row 2
                    c20 <= a20*b00 + a21*b10 + a22*b20;
                    c21 <= a20*b01 + a21*b11 + a22*b21;
                    c22 <= a20*b02 + a21*b12 + a22*b22;
                    
                    state <= DONE;
                end
                
                DONE: begin
                    done <= 1'b1;
                    busy <= 1'b0;
                    if (!start) begin
                        state <= IDLE;
                    end
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule