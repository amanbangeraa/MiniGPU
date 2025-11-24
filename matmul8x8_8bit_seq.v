// ==========================================================
// 8-bit MAC (Multiply + Accumulate)
// a_in, b_in -> signed 8-bit
// product -> signed 16-bit
// psum_out -> signed 16-bit accumulated result
// ==========================================================
module pe_mac8 (
    input clk,
    input rst,
    input clear,           // clear accumulator
    input valid,           // accumulate when 1
    input signed [7:0] a_in,
    input signed [7:0] b_in,
    output reg signed [15:0] psum_out
);

    wire signed [15:0] product;
    assign product = a_in * b_in;

    always @(posedge clk) begin
        if (rst) begin
            psum_out <= 16'sd0;
        end
        else if (clear) begin
            psum_out <= 16'sd0;
        end
        else if (valid) begin
            psum_out <= psum_out + product;
        end
    end
endmodule

// ======================================================================
// 8×8 MATRIX MULTIPLICATION (8-bit signed inputs → 16-bit outputs)
// Sequential architecture using one MAC (pe_mac8)
//
// A, B : 8×8 matrix, flattened, row-major, each element 8 bits
// C : output 8×8 matrix, flattened, each element 16 bits
//
// start : pulse for 1 cycle
// done : goes HIGH when complete
// ======================================================================
module matmul8x8_8bit_seq (
    input clk,
    input rst,
    input start,
    input signed [511:0] A,    // 8×8 × 8 bits = 512 bits
    input signed [511:0] B,    // 8×8 × 8 bits = 512 bits
    output reg signed [1023:0] C,  // 8×8 × 16 bits = 1024 bits
    output reg done
);

    localparam N = 8;

    // -------------------------------
    // Decode A, B into 2D arrays
    // -------------------------------
    wire signed [7:0] A_mat [0:N-1][0:N-1];
    wire signed [7:0] B_mat [0:N-1][0:N-1];

    genvar i1, j1;
    generate
        for (i1 = 0; i1 < N; i1 = i1 + 1) begin : GEN_A
            for (j1 = 0; j1 < N; j1 = j1 + 1) begin : GEN_A2
                assign A_mat[i1][j1] = A[(i1*N + j1)*8 +: 8];
            end
        end
        for (i1 = 0; i1 < N; i1 = i1 + 1) begin : GEN_B
            for (j1 = 0; j1 < N; j1 = j1 + 1) begin : GEN_B2
                assign B_mat[i1][j1] = B[(i1*N + j1)*8 +: 8];
            end
        end
    endgenerate

    // Storage for final results
    reg signed [15:0] C_mat [0:N-1][0:N-1];

    // Loop counters
    reg [2:0] i, j, k;

    // MAC control
    reg mac_clear;
    reg mac_valid;
    reg signed [7:0] mac_a_in;
    reg signed [7:0] mac_b_in;
    wire signed [15:0] mac_psum;

    pe_mac8 u_mac (
        .clk(clk),
        .rst(rst),
        .clear(mac_clear),
        .valid(mac_valid),
        .a_in(mac_a_in),
        .b_in(mac_b_in),
        .psum_out(mac_psum)
    );

    // FSM states
    localparam S_IDLE  = 3'd0;
    localparam S_CLEAR = 3'd1;
    localparam S_ACCUM = 3'd2;
    localparam S_STORE = 3'd3;
    localparam S_DONE  = 3'd4;

    reg [2:0] state, next_state;

    // ==========================================================
    // STATE + LOOP REGISTERS
    // ==========================================================
    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
            done <= 0;
            i <= 0;
            j <= 0;
            k <= 0;
        end else begin
            state <= next_state;
            case (state)
                S_IDLE: begin
                    done <= 0;
                    if (start) begin
                        i <= 0;
                        j <= 0;
                        k <= 0;
                    end
                end
                S_CLEAR: begin
                    k <= 0;
                end
                S_ACCUM: begin
                    if (k < N-1)
                        k <= k + 1;
                end
                S_STORE: begin
                    if (j < N-1)
                        j <= j + 1;
                    else begin
                        j <= 0;
                        if (i < N-1)
                            i <= i + 1;
                    end
                end
                S_DONE: begin
                    done <= 1;
                end
            endcase
        end
    end

    // ==========================================================
    // FSM NEXT-STATE + MAC CONTROL
    // ==========================================================
    always @(*) begin
        next_state = state;
        mac_clear = 0;
        mac_valid = 0;
        mac_a_in = 0;
        mac_b_in = 0;

        case (state)
            S_IDLE: begin
                if (start)
                    next_state = S_CLEAR;
            end
            S_CLEAR: begin
                mac_clear = 1;
                next_state = S_ACCUM;
            end
            S_ACCUM: begin
                mac_valid = 1;
                mac_a_in = A_mat[i][k];
                mac_b_in = B_mat[k][j];
                if (k == N-1)
                    next_state = S_STORE;
            end
            S_STORE: begin
                if (i == N-1 && j == N-1)
                    next_state = S_DONE;
                else
                    next_state = S_CLEAR;
            end
            S_DONE: begin
                if (start)
                    next_state = S_CLEAR;
            end
        endcase
    end

    // ==========================================================
    // STORE RESULT (Non-blocking assignment in clocked block)
    // ==========================================================
    integer init_i, init_j;
    always @(posedge clk) begin
        if (rst) begin
            // Initialize C_mat to zero
            for (init_i = 0; init_i < N; init_i = init_i + 1)
                for (init_j = 0; init_j < N; init_j = init_j + 1)
                    C_mat[init_i][init_j] <= 16'sd0;
        end else if (state == S_STORE) begin
            C_mat[i][j] <= mac_psum;
        end
    end

    // ==========================================================
    // FLATTEN C_mat → C output bus
    // ==========================================================
    integer x, y;
    always @(*) begin
        for (x = 0; x < N; x = x + 1)
            for (y = 0; y < N; y = y + 1)
                C[(x*N + y)*16 +: 16] = C_mat[x][y];
    end

endmodule