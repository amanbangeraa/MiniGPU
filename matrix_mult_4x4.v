// 4x4 Matrix Multiplication Unit
// Uses 16 PEs arranged in a 4x4 grid

module matrix_mult_4x4 #(
    parameter DATA_WIDTH = 16
) (
    input clk,
    input rst_n,
    input enable,
    input start,
    
    // Matrix A inputs (4x4) - flattened array
    input signed [DATA_WIDTH-1:0] matrix_a [0:15],
    
    // Matrix B inputs (4x4) - flattened array
    input signed [DATA_WIDTH-1:0] matrix_b [0:15],
    
    // Result matrix C (4x4) - flattened array
    output reg signed [2*DATA_WIDTH-1:0] matrix_c [0:15],
    output reg done
);

    reg [2:0] state;
    reg [2:0] cycle_count;
    reg pe_enable;
    reg pe_clear;
    
    wire signed [DATA_WIDTH-1:0] pe_a_in [0:15];
    wire signed [DATA_WIDTH-1:0] pe_b_in [0:15];
    wire signed [2*DATA_WIDTH-1:0] pe_c_out [0:15];
    wire pe_valid [0:15];

    // PE array instantiation
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pe_array
            processing_element #(.DATA_WIDTH(DATA_WIDTH)) pe (
                .clk(clk),
                .rst_n(rst_n),
                .enable(pe_enable),
                .clear_acc(pe_clear),
                .a_in(pe_a_in[i]),
                .b_in(pe_b_in[i]),
                .c_out(pe_c_out[i]),
                .valid(pe_valid[i])
            );
        end
    endgenerate

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            cycle_count <= 0;
            pe_enable <= 0;
            pe_clear <= 1;
            done <= 0;
        end else begin
            case (state)
                0: begin // IDLE
                    if (start && enable) begin
                        state <= 1;
                        pe_clear <= 1;
                        cycle_count <= 0;
                        done <= 0;
                    end
                end
                
                1: begin // CLEAR
                    pe_clear <= 0;
                    pe_enable <= 1;
                    state <= 2;
                end
                
                2: begin // COMPUTE
                    cycle_count <= cycle_count + 1;
                    if (cycle_count == 4) begin
                        state <= 3;
                        pe_enable <= 0;
                    end
                end
                
                3: begin // DONE
                    for (integer j = 0; j < 16; j = j + 1) begin
                        matrix_c[j] <= pe_c_out[j];
                    end
                    done <= 1;
                    state <= 0;
                end
            endcase
        end
    end

    // Input assignment for matrix multiplication
    integer row, col, k;
    always @(*) begin
        for (row = 0; row < 4; row = row + 1) begin
            for (col = 0; col < 4; col = col + 1) begin
                if (cycle_count < 4) begin
                    k = cycle_count;
                    pe_a_in[row*4 + col] = matrix_a[row*4 + k];
                    pe_b_in[row*4 + col] = matrix_b[k*4 + col];
                end else begin
                    pe_a_in[row*4 + col] = 0;
                    pe_b_in[row*4 + col] = 0;
                end
            end
        end
    end

endmodule