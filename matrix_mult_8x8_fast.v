module matrix_mult_8x8_fast(
    input clk,
    input rst,
    input start,
    input [31:0] a00, a01, a02, a03, a04, a05, a06, a07,
    input [31:0] a10, a11, a12, a13, a14, a15, a16, a17,
    input [31:0] a20, a21, a22, a23, a24, a25, a26, a27,
    input [31:0] a30, a31, a32, a33, a34, a35, a36, a37,
    input [31:0] a40, a41, a42, a43, a44, a45, a46, a47,
    input [31:0] a50, a51, a52, a53, a54, a55, a56, a57,
    input [31:0] a60, a61, a62, a63, a64, a65, a66, a67,
    input [31:0] a70, a71, a72, a73, a74, a75, a76, a77,
    input [31:0] b00, b01, b02, b03, b04, b05, b06, b07,
    input [31:0] b10, b11, b12, b13, b14, b15, b16, b17,
    input [31:0] b20, b21, b22, b23, b24, b25, b26, b27,
    input [31:0] b30, b31, b32, b33, b34, b35, b36, b37,
    input [31:0] b40, b41, b42, b43, b44, b45, b46, b47,
    input [31:0] b50, b51, b52, b53, b54, b55, b56, b57,
    input [31:0] b60, b61, b62, b63, b64, b65, b66, b67,
    input [31:0] b70, b71, b72, b73, b74, b75, b76, b77,
    output reg [31:0] c00, c01, c02, c03, c04, c05, c06, c07,
    output reg [31:0] c10, c11, c12, c13, c14, c15, c16, c17,
    output reg [31:0] c20, c21, c22, c23, c24, c25, c26, c27,
    output reg [31:0] c30, c31, c32, c33, c34, c35, c36, c37,
    output reg [31:0] c40, c41, c42, c43, c44, c45, c46, c47,
    output reg [31:0] c50, c51, c52, c53, c54, c55, c56, c57,
    output reg [31:0] c60, c61, c62, c63, c64, c65, c66, c67,
    output reg [31:0] c70, c71, c72, c73, c74, c75, c76, c77,
    output reg done,
    output busy
);

    reg [2:0] state;
    reg [31:0] a_reg[0:7][0:7];
    reg [31:0] b_reg[0:7][0:7];
    
    assign busy = ~done;
    
    // Pipelined computation - completes in 8 clock cycles
    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            done <= 0;
        end else if (start && state == 0) begin
            // Load matrices (cycle 0)
            a_reg[0][0] <= a00; a_reg[0][1] <= a01; a_reg[0][2] <= a02; a_reg[0][3] <= a03; 
            a_reg[0][4] <= a04; a_reg[0][5] <= a05; a_reg[0][6] <= a06; a_reg[0][7] <= a07;
            a_reg[1][0] <= a10; a_reg[1][1] <= a11; a_reg[1][2] <= a12; a_reg[1][3] <= a13; 
            a_reg[1][4] <= a14; a_reg[1][5] <= a15; a_reg[1][6] <= a16; a_reg[1][7] <= a17;
            a_reg[2][0] <= a20; a_reg[2][1] <= a21; a_reg[2][2] <= a22; a_reg[2][3] <= a23; 
            a_reg[2][4] <= a24; a_reg[2][5] <= a25; a_reg[2][6] <= a26; a_reg[2][7] <= a27;
            a_reg[3][0] <= a30; a_reg[3][1] <= a31; a_reg[3][2] <= a32; a_reg[3][3] <= a33; 
            a_reg[3][4] <= a34; a_reg[3][5] <= a35; a_reg[3][6] <= a36; a_reg[3][7] <= a37;
            a_reg[4][0] <= a40; a_reg[4][1] <= a41; a_reg[4][2] <= a42; a_reg[4][3] <= a43; 
            a_reg[4][4] <= a44; a_reg[4][5] <= a45; a_reg[4][6] <= a46; a_reg[4][7] <= a47;
            a_reg[5][0] <= a50; a_reg[5][1] <= a51; a_reg[5][2] <= a52; a_reg[5][3] <= a53; 
            a_reg[5][4] <= a54; a_reg[5][5] <= a55; a_reg[5][6] <= a56; a_reg[5][7] <= a57;
            a_reg[6][0] <= a60; a_reg[6][1] <= a61; a_reg[6][2] <= a62; a_reg[6][3] <= a63; 
            a_reg[6][4] <= a64; a_reg[6][5] <= a65; a_reg[6][6] <= a66; a_reg[6][7] <= a67;
            a_reg[7][0] <= a70; a_reg[7][1] <= a71; a_reg[7][2] <= a72; a_reg[7][3] <= a73; 
            a_reg[7][4] <= a74; a_reg[7][5] <= a75; a_reg[7][6] <= a76; a_reg[7][7] <= a77;
            
            b_reg[0][0] <= b00; b_reg[0][1] <= b01; b_reg[0][2] <= b02; b_reg[0][3] <= b03; 
            b_reg[0][4] <= b04; b_reg[0][5] <= b05; b_reg[0][6] <= b06; b_reg[0][7] <= b07;
            b_reg[1][0] <= b10; b_reg[1][1] <= b11; b_reg[1][2] <= b12; b_reg[1][3] <= b13; 
            b_reg[1][4] <= b14; b_reg[1][5] <= b15; b_reg[1][6] <= b16; b_reg[1][7] <= b17;
            b_reg[2][0] <= b20; b_reg[2][1] <= b21; b_reg[2][2] <= b22; b_reg[2][3] <= b23; 
            b_reg[2][4] <= b24; b_reg[2][5] <= b25; b_reg[2][6] <= b26; b_reg[2][7] <= b27;
            b_reg[3][0] <= b30; b_reg[3][1] <= b31; b_reg[3][2] <= b32; b_reg[3][3] <= b33; 
            b_reg[3][4] <= b34; b_reg[3][5] <= b35; b_reg[3][6] <= b36; b_reg[3][7] <= b37;
            b_reg[4][0] <= b40; b_reg[4][1] <= b41; b_reg[4][2] <= b42; b_reg[4][3] <= b43; 
            b_reg[4][4] <= b44; b_reg[4][5] <= b45; b_reg[4][6] <= b46; b_reg[4][7] <= b47;
            b_reg[5][0] <= b50; b_reg[5][1] <= b51; b_reg[5][2] <= b52; b_reg[5][3] <= b53; 
            b_reg[5][4] <= b54; b_reg[5][5] <= b55; b_reg[5][6] <= b56; b_reg[5][7] <= b57;
            b_reg[6][0] <= b60; b_reg[6][1] <= b61; b_reg[6][2] <= b62; b_reg[6][3] <= b63; 
            b_reg[6][4] <= b64; b_reg[6][5] <= b65; b_reg[6][6] <= b66; b_reg[6][7] <= b67;
            b_reg[7][0] <= b70; b_reg[7][1] <= b71; b_reg[7][2] <= b72; b_reg[7][3] <= b73; 
            b_reg[7][4] <= b74; b_reg[7][5] <= b75; b_reg[7][6] <= b76; b_reg[7][7] <= b77;
            
            state <= 1;
            done <= 0;
        end else if (state == 1) begin
            // Compute matrix multiplication in parallel (cycle 1)
            c00 <= a_reg[0][0]*b_reg[0][0] + a_reg[0][1]*b_reg[1][0] + a_reg[0][2]*b_reg[2][0] + a_reg[0][3]*b_reg[3][0] + a_reg[0][4]*b_reg[4][0] + a_reg[0][5]*b_reg[5][0] + a_reg[0][6]*b_reg[6][0] + a_reg[0][7]*b_reg[7][0];
            c01 <= a_reg[0][0]*b_reg[0][1] + a_reg[0][1]*b_reg[1][1] + a_reg[0][2]*b_reg[2][1] + a_reg[0][3]*b_reg[3][1] + a_reg[0][4]*b_reg[4][1] + a_reg[0][5]*b_reg[5][1] + a_reg[0][6]*b_reg[6][1] + a_reg[0][7]*b_reg[7][1];
            c02 <= a_reg[0][0]*b_reg[0][2] + a_reg[0][1]*b_reg[1][2] + a_reg[0][2]*b_reg[2][2] + a_reg[0][3]*b_reg[3][2] + a_reg[0][4]*b_reg[4][2] + a_reg[0][5]*b_reg[5][2] + a_reg[0][6]*b_reg[6][2] + a_reg[0][7]*b_reg[7][2];
            c03 <= a_reg[0][0]*b_reg[0][3] + a_reg[0][1]*b_reg[1][3] + a_reg[0][2]*b_reg[2][3] + a_reg[0][3]*b_reg[3][3] + a_reg[0][4]*b_reg[4][3] + a_reg[0][5]*b_reg[5][3] + a_reg[0][6]*b_reg[6][3] + a_reg[0][7]*b_reg[7][3];
            c04 <= a_reg[0][0]*b_reg[0][4] + a_reg[0][1]*b_reg[1][4] + a_reg[0][2]*b_reg[2][4] + a_reg[0][3]*b_reg[3][4] + a_reg[0][4]*b_reg[4][4] + a_reg[0][5]*b_reg[5][4] + a_reg[0][6]*b_reg[6][4] + a_reg[0][7]*b_reg[7][4];
            c05 <= a_reg[0][0]*b_reg[0][5] + a_reg[0][1]*b_reg[1][5] + a_reg[0][2]*b_reg[2][5] + a_reg[0][3]*b_reg[3][5] + a_reg[0][4]*b_reg[4][5] + a_reg[0][5]*b_reg[5][5] + a_reg[0][6]*b_reg[6][5] + a_reg[0][7]*b_reg[7][5];
            c06 <= a_reg[0][0]*b_reg[0][6] + a_reg[0][1]*b_reg[1][6] + a_reg[0][2]*b_reg[2][6] + a_reg[0][3]*b_reg[3][6] + a_reg[0][4]*b_reg[4][6] + a_reg[0][5]*b_reg[5][6] + a_reg[0][6]*b_reg[6][6] + a_reg[0][7]*b_reg[7][6];
            c07 <= a_reg[0][0]*b_reg[0][7] + a_reg[0][1]*b_reg[1][7] + a_reg[0][2]*b_reg[2][7] + a_reg[0][3]*b_reg[3][7] + a_reg[0][4]*b_reg[4][7] + a_reg[0][5]*b_reg[5][7] + a_reg[0][6]*b_reg[6][7] + a_reg[0][7]*b_reg[7][7];
            
            c10 <= a_reg[1][0]*b_reg[0][0] + a_reg[1][1]*b_reg[1][0] + a_reg[1][2]*b_reg[2][0] + a_reg[1][3]*b_reg[3][0] + a_reg[1][4]*b_reg[4][0] + a_reg[1][5]*b_reg[5][0] + a_reg[1][6]*b_reg[6][0] + a_reg[1][7]*b_reg[7][0];
            c11 <= a_reg[1][0]*b_reg[0][1] + a_reg[1][1]*b_reg[1][1] + a_reg[1][2]*b_reg[2][1] + a_reg[1][3]*b_reg[3][1] + a_reg[1][4]*b_reg[4][1] + a_reg[1][5]*b_reg[5][1] + a_reg[1][6]*b_reg[6][1] + a_reg[1][7]*b_reg[7][1];
            c12 <= a_reg[1][0]*b_reg[0][2] + a_reg[1][1]*b_reg[1][2] + a_reg[1][2]*b_reg[2][2] + a_reg[1][3]*b_reg[3][2] + a_reg[1][4]*b_reg[4][2] + a_reg[1][5]*b_reg[5][2] + a_reg[1][6]*b_reg[6][2] + a_reg[1][7]*b_reg[7][2];
            c13 <= a_reg[1][0]*b_reg[0][3] + a_reg[1][1]*b_reg[1][3] + a_reg[1][2]*b_reg[2][3] + a_reg[1][3]*b_reg[3][3] + a_reg[1][4]*b_reg[4][3] + a_reg[1][5]*b_reg[5][3] + a_reg[1][6]*b_reg[6][3] + a_reg[1][7]*b_reg[7][3];
            c14 <= a_reg[1][0]*b_reg[0][4] + a_reg[1][1]*b_reg[1][4] + a_reg[1][2]*b_reg[2][4] + a_reg[1][3]*b_reg[3][4] + a_reg[1][4]*b_reg[4][4] + a_reg[1][5]*b_reg[5][4] + a_reg[1][6]*b_reg[6][4] + a_reg[1][7]*b_reg[7][4];
            c15 <= a_reg[1][0]*b_reg[0][5] + a_reg[1][1]*b_reg[1][5] + a_reg[1][2]*b_reg[2][5] + a_reg[1][3]*b_reg[3][5] + a_reg[1][4]*b_reg[4][5] + a_reg[1][5]*b_reg[5][5] + a_reg[1][6]*b_reg[6][5] + a_reg[1][7]*b_reg[7][5];
            c16 <= a_reg[1][0]*b_reg[0][6] + a_reg[1][1]*b_reg[1][6] + a_reg[1][2]*b_reg[2][6] + a_reg[1][3]*b_reg[3][6] + a_reg[1][4]*b_reg[4][6] + a_reg[1][5]*b_reg[5][6] + a_reg[1][6]*b_reg[6][6] + a_reg[1][7]*b_reg[7][6];
            c17 <= a_reg[1][0]*b_reg[0][7] + a_reg[1][1]*b_reg[1][7] + a_reg[1][2]*b_reg[2][7] + a_reg[1][3]*b_reg[3][7] + a_reg[1][4]*b_reg[4][7] + a_reg[1][5]*b_reg[5][7] + a_reg[1][6]*b_reg[6][7] + a_reg[1][7]*b_reg[7][7];
            
            c20 <= a_reg[2][0]*b_reg[0][0] + a_reg[2][1]*b_reg[1][0] + a_reg[2][2]*b_reg[2][0] + a_reg[2][3]*b_reg[3][0] + a_reg[2][4]*b_reg[4][0] + a_reg[2][5]*b_reg[5][0] + a_reg[2][6]*b_reg[6][0] + a_reg[2][7]*b_reg[7][0];
            c21 <= a_reg[2][0]*b_reg[0][1] + a_reg[2][1]*b_reg[1][1] + a_reg[2][2]*b_reg[2][1] + a_reg[2][3]*b_reg[3][1] + a_reg[2][4]*b_reg[4][1] + a_reg[2][5]*b_reg[5][1] + a_reg[2][6]*b_reg[6][1] + a_reg[2][7]*b_reg[7][1];
            c22 <= a_reg[2][0]*b_reg[0][2] + a_reg[2][1]*b_reg[1][2] + a_reg[2][2]*b_reg[2][2] + a_reg[2][3]*b_reg[3][2] + a_reg[2][4]*b_reg[4][2] + a_reg[2][5]*b_reg[5][2] + a_reg[2][6]*b_reg[6][2] + a_reg[2][7]*b_reg[7][2];
            c23 <= a_reg[2][0]*b_reg[0][3] + a_reg[2][1]*b_reg[1][3] + a_reg[2][2]*b_reg[2][3] + a_reg[2][3]*b_reg[3][3] + a_reg[2][4]*b_reg[4][3] + a_reg[2][5]*b_reg[5][3] + a_reg[2][6]*b_reg[6][3] + a_reg[2][7]*b_reg[7][3];
            c24 <= a_reg[2][0]*b_reg[0][4] + a_reg[2][1]*b_reg[1][4] + a_reg[2][2]*b_reg[2][4] + a_reg[2][3]*b_reg[3][4] + a_reg[2][4]*b_reg[4][4] + a_reg[2][5]*b_reg[5][4] + a_reg[2][6]*b_reg[6][4] + a_reg[2][7]*b_reg[7][4];
            c25 <= a_reg[2][0]*b_reg[0][5] + a_reg[2][1]*b_reg[1][5] + a_reg[2][2]*b_reg[2][5] + a_reg[2][3]*b_reg[3][5] + a_reg[2][4]*b_reg[4][5] + a_reg[2][5]*b_reg[5][5] + a_reg[2][6]*b_reg[6][5] + a_reg[2][7]*b_reg[7][5];
            c26 <= a_reg[2][0]*b_reg[0][6] + a_reg[2][1]*b_reg[1][6] + a_reg[2][2]*b_reg[2][6] + a_reg[2][3]*b_reg[3][6] + a_reg[2][4]*b_reg[4][6] + a_reg[2][5]*b_reg[5][6] + a_reg[2][6]*b_reg[6][6] + a_reg[2][7]*b_reg[7][6];
            c27 <= a_reg[2][0]*b_reg[0][7] + a_reg[2][1]*b_reg[1][7] + a_reg[2][2]*b_reg[2][7] + a_reg[2][3]*b_reg[3][7] + a_reg[2][4]*b_reg[4][7] + a_reg[2][5]*b_reg[5][7] + a_reg[2][6]*b_reg[6][7] + a_reg[2][7]*b_reg[7][7];
            
            c30 <= a_reg[3][0]*b_reg[0][0] + a_reg[3][1]*b_reg[1][0] + a_reg[3][2]*b_reg[2][0] + a_reg[3][3]*b_reg[3][0] + a_reg[3][4]*b_reg[4][0] + a_reg[3][5]*b_reg[5][0] + a_reg[3][6]*b_reg[6][0] + a_reg[3][7]*b_reg[7][0];
            c31 <= a_reg[3][0]*b_reg[0][1] + a_reg[3][1]*b_reg[1][1] + a_reg[3][2]*b_reg[2][1] + a_reg[3][3]*b_reg[3][1] + a_reg[3][4]*b_reg[4][1] + a_reg[3][5]*b_reg[5][1] + a_reg[3][6]*b_reg[6][1] + a_reg[3][7]*b_reg[7][1];
            c32 <= a_reg[3][0]*b_reg[0][2] + a_reg[3][1]*b_reg[1][2] + a_reg[3][2]*b_reg[2][2] + a_reg[3][3]*b_reg[3][2] + a_reg[3][4]*b_reg[4][2] + a_reg[3][5]*b_reg[5][2] + a_reg[3][6]*b_reg[6][2] + a_reg[3][7]*b_reg[7][2];
            c33 <= a_reg[3][0]*b_reg[0][3] + a_reg[3][1]*b_reg[1][3] + a_reg[3][2]*b_reg[2][3] + a_reg[3][3]*b_reg[3][3] + a_reg[3][4]*b_reg[4][3] + a_reg[3][5]*b_reg[5][3] + a_reg[3][6]*b_reg[6][3] + a_reg[3][7]*b_reg[7][3];
            c34 <= a_reg[3][0]*b_reg[0][4] + a_reg[3][1]*b_reg[1][4] + a_reg[3][2]*b_reg[2][4] + a_reg[3][3]*b_reg[3][4] + a_reg[3][4]*b_reg[4][4] + a_reg[3][5]*b_reg[5][4] + a_reg[3][6]*b_reg[6][4] + a_reg[3][7]*b_reg[7][4];
            c35 <= a_reg[3][0]*b_reg[0][5] + a_reg[3][1]*b_reg[1][5] + a_reg[3][2]*b_reg[2][5] + a_reg[3][3]*b_reg[3][5] + a_reg[3][4]*b_reg[4][5] + a_reg[3][5]*b_reg[5][5] + a_reg[3][6]*b_reg[6][5] + a_reg[3][7]*b_reg[7][5];
            c36 <= a_reg[3][0]*b_reg[0][6] + a_reg[3][1]*b_reg[1][6] + a_reg[3][2]*b_reg[2][6] + a_reg[3][3]*b_reg[3][6] + a_reg[3][4]*b_reg[4][6] + a_reg[3][5]*b_reg[5][6] + a_reg[3][6]*b_reg[6][6] + a_reg[3][7]*b_reg[7][6];
            c37 <= a_reg[3][0]*b_reg[0][7] + a_reg[3][1]*b_reg[1][7] + a_reg[3][2]*b_reg[2][7] + a_reg[3][3]*b_reg[3][7] + a_reg[3][4]*b_reg[4][7] + a_reg[3][5]*b_reg[5][7] + a_reg[3][6]*b_reg[6][7] + a_reg[3][7]*b_reg[7][7];
            
            c40 <= a_reg[4][0]*b_reg[0][0] + a_reg[4][1]*b_reg[1][0] + a_reg[4][2]*b_reg[2][0] + a_reg[4][3]*b_reg[3][0] + a_reg[4][4]*b_reg[4][0] + a_reg[4][5]*b_reg[5][0] + a_reg[4][6]*b_reg[6][0] + a_reg[4][7]*b_reg[7][0];
            c41 <= a_reg[4][0]*b_reg[0][1] + a_reg[4][1]*b_reg[1][1] + a_reg[4][2]*b_reg[2][1] + a_reg[4][3]*b_reg[3][1] + a_reg[4][4]*b_reg[4][1] + a_reg[4][5]*b_reg[5][1] + a_reg[4][6]*b_reg[6][1] + a_reg[4][7]*b_reg[7][1];
            c42 <= a_reg[4][0]*b_reg[0][2] + a_reg[4][1]*b_reg[1][2] + a_reg[4][2]*b_reg[2][2] + a_reg[4][3]*b_reg[3][2] + a_reg[4][4]*b_reg[4][2] + a_reg[4][5]*b_reg[5][2] + a_reg[4][6]*b_reg[6][2] + a_reg[4][7]*b_reg[7][2];
            c43 <= a_reg[4][0]*b_reg[0][3] + a_reg[4][1]*b_reg[1][3] + a_reg[4][2]*b_reg[2][3] + a_reg[4][3]*b_reg[3][3] + a_reg[4][4]*b_reg[4][3] + a_reg[4][5]*b_reg[5][3] + a_reg[4][6]*b_reg[6][3] + a_reg[4][7]*b_reg[7][3];
            c44 <= a_reg[4][0]*b_reg[0][4] + a_reg[4][1]*b_reg[1][4] + a_reg[4][2]*b_reg[2][4] + a_reg[4][3]*b_reg[3][4] + a_reg[4][4]*b_reg[4][4] + a_reg[4][5]*b_reg[5][4] + a_reg[4][6]*b_reg[6][4] + a_reg[4][7]*b_reg[7][4];
            c45 <= a_reg[4][0]*b_reg[0][5] + a_reg[4][1]*b_reg[1][5] + a_reg[4][2]*b_reg[2][5] + a_reg[4][3]*b_reg[3][5] + a_reg[4][4]*b_reg[4][5] + a_reg[4][5]*b_reg[5][5] + a_reg[4][6]*b_reg[6][5] + a_reg[4][7]*b_reg[7][5];
            c46 <= a_reg[4][0]*b_reg[0][6] + a_reg[4][1]*b_reg[1][6] + a_reg[4][2]*b_reg[2][6] + a_reg[4][3]*b_reg[3][6] + a_reg[4][4]*b_reg[4][6] + a_reg[4][5]*b_reg[5][6] + a_reg[4][6]*b_reg[6][6] + a_reg[4][7]*b_reg[7][6];
            c47 <= a_reg[4][0]*b_reg[0][7] + a_reg[4][1]*b_reg[1][7] + a_reg[4][2]*b_reg[2][7] + a_reg[4][3]*b_reg[3][7] + a_reg[4][4]*b_reg[4][7] + a_reg[4][5]*b_reg[5][7] + a_reg[4][6]*b_reg[6][7] + a_reg[4][7]*b_reg[7][7];
            
            c50 <= a_reg[5][0]*b_reg[0][0] + a_reg[5][1]*b_reg[1][0] + a_reg[5][2]*b_reg[2][0] + a_reg[5][3]*b_reg[3][0] + a_reg[5][4]*b_reg[4][0] + a_reg[5][5]*b_reg[5][0] + a_reg[5][6]*b_reg[6][0] + a_reg[5][7]*b_reg[7][0];
            c51 <= a_reg[5][0]*b_reg[0][1] + a_reg[5][1]*b_reg[1][1] + a_reg[5][2]*b_reg[2][1] + a_reg[5][3]*b_reg[3][1] + a_reg[5][4]*b_reg[4][1] + a_reg[5][5]*b_reg[5][1] + a_reg[5][6]*b_reg[6][1] + a_reg[5][7]*b_reg[7][1];
            c52 <= a_reg[5][0]*b_reg[0][2] + a_reg[5][1]*b_reg[1][2] + a_reg[5][2]*b_reg[2][2] + a_reg[5][3]*b_reg[3][2] + a_reg[5][4]*b_reg[4][2] + a_reg[5][5]*b_reg[5][2] + a_reg[5][6]*b_reg[6][2] + a_reg[5][7]*b_reg[7][2];
            c53 <= a_reg[5][0]*b_reg[0][3] + a_reg[5][1]*b_reg[1][3] + a_reg[5][2]*b_reg[2][3] + a_reg[5][3]*b_reg[3][3] + a_reg[5][4]*b_reg[4][3] + a_reg[5][5]*b_reg[5][3] + a_reg[5][6]*b_reg[6][3] + a_reg[5][7]*b_reg[7][3];
            c54 <= a_reg[5][0]*b_reg[0][4] + a_reg[5][1]*b_reg[1][4] + a_reg[5][2]*b_reg[2][4] + a_reg[5][3]*b_reg[3][4] + a_reg[5][4]*b_reg[4][4] + a_reg[5][5]*b_reg[5][4] + a_reg[5][6]*b_reg[6][4] + a_reg[5][7]*b_reg[7][4];
            c55 <= a_reg[5][0]*b_reg[0][5] + a_reg[5][1]*b_reg[1][5] + a_reg[5][2]*b_reg[2][5] + a_reg[5][3]*b_reg[3][5] + a_reg[5][4]*b_reg[4][5] + a_reg[5][5]*b_reg[5][5] + a_reg[5][6]*b_reg[6][5] + a_reg[5][7]*b_reg[7][5];
            c56 <= a_reg[5][0]*b_reg[0][6] + a_reg[5][1]*b_reg[1][6] + a_reg[5][2]*b_reg[2][6] + a_reg[5][3]*b_reg[3][6] + a_reg[5][4]*b_reg[4][6] + a_reg[5][5]*b_reg[5][6] + a_reg[5][6]*b_reg[6][6] + a_reg[5][7]*b_reg[7][6];
            c57 <= a_reg[5][0]*b_reg[0][7] + a_reg[5][1]*b_reg[1][7] + a_reg[5][2]*b_reg[2][7] + a_reg[5][3]*b_reg[3][7] + a_reg[5][4]*b_reg[4][7] + a_reg[5][5]*b_reg[5][7] + a_reg[5][6]*b_reg[6][7] + a_reg[5][7]*b_reg[7][7];
            
            c60 <= a_reg[6][0]*b_reg[0][0] + a_reg[6][1]*b_reg[1][0] + a_reg[6][2]*b_reg[2][0] + a_reg[6][3]*b_reg[3][0] + a_reg[6][4]*b_reg[4][0] + a_reg[6][5]*b_reg[5][0] + a_reg[6][6]*b_reg[6][0] + a_reg[6][7]*b_reg[7][0];
            c61 <= a_reg[6][0]*b_reg[0][1] + a_reg[6][1]*b_reg[1][1] + a_reg[6][2]*b_reg[2][1] + a_reg[6][3]*b_reg[3][1] + a_reg[6][4]*b_reg[4][1] + a_reg[6][5]*b_reg[5][1] + a_reg[6][6]*b_reg[6][1] + a_reg[6][7]*b_reg[7][1];
            c62 <= a_reg[6][0]*b_reg[0][2] + a_reg[6][1]*b_reg[1][2] + a_reg[6][2]*b_reg[2][2] + a_reg[6][3]*b_reg[3][2] + a_reg[6][4]*b_reg[4][2] + a_reg[6][5]*b_reg[5][2] + a_reg[6][6]*b_reg[6][2] + a_reg[6][7]*b_reg[7][2];
            c63 <= a_reg[6][0]*b_reg[0][3] + a_reg[6][1]*b_reg[1][3] + a_reg[6][2]*b_reg[2][3] + a_reg[6][3]*b_reg[3][3] + a_reg[6][4]*b_reg[4][3] + a_reg[6][5]*b_reg[5][3] + a_reg[6][6]*b_reg[6][3] + a_reg[6][7]*b_reg[7][3];
            c64 <= a_reg[6][0]*b_reg[0][4] + a_reg[6][1]*b_reg[1][4] + a_reg[6][2]*b_reg[2][4] + a_reg[6][3]*b_reg[3][4] + a_reg[6][4]*b_reg[4][4] + a_reg[6][5]*b_reg[5][4] + a_reg[6][6]*b_reg[6][4] + a_reg[6][7]*b_reg[7][4];
            c65 <= a_reg[6][0]*b_reg[0][5] + a_reg[6][1]*b_reg[1][5] + a_reg[6][2]*b_reg[2][5] + a_reg[6][3]*b_reg[3][5] + a_reg[6][4]*b_reg[4][5] + a_reg[6][5]*b_reg[5][5] + a_reg[6][6]*b_reg[6][5] + a_reg[6][7]*b_reg[7][5];
            c66 <= a_reg[6][0]*b_reg[0][6] + a_reg[6][1]*b_reg[1][6] + a_reg[6][2]*b_reg[2][6] + a_reg[6][3]*b_reg[3][6] + a_reg[6][4]*b_reg[4][6] + a_reg[6][5]*b_reg[5][6] + a_reg[6][6]*b_reg[6][6] + a_reg[6][7]*b_reg[7][6];
            c67 <= a_reg[6][0]*b_reg[0][7] + a_reg[6][1]*b_reg[1][7] + a_reg[6][2]*b_reg[2][7] + a_reg[6][3]*b_reg[3][7] + a_reg[6][4]*b_reg[4][7] + a_reg[6][5]*b_reg[5][7] + a_reg[6][6]*b_reg[6][7] + a_reg[6][7]*b_reg[7][7];
            
            c70 <= a_reg[7][0]*b_reg[0][0] + a_reg[7][1]*b_reg[1][0] + a_reg[7][2]*b_reg[2][0] + a_reg[7][3]*b_reg[3][0] + a_reg[7][4]*b_reg[4][0] + a_reg[7][5]*b_reg[5][0] + a_reg[7][6]*b_reg[6][0] + a_reg[7][7]*b_reg[7][0];
            c71 <= a_reg[7][0]*b_reg[0][1] + a_reg[7][1]*b_reg[1][1] + a_reg[7][2]*b_reg[2][1] + a_reg[7][3]*b_reg[3][1] + a_reg[7][4]*b_reg[4][1] + a_reg[7][5]*b_reg[5][1] + a_reg[7][6]*b_reg[6][1] + a_reg[7][7]*b_reg[7][1];
            c72 <= a_reg[7][0]*b_reg[0][2] + a_reg[7][1]*b_reg[1][2] + a_reg[7][2]*b_reg[2][2] + a_reg[7][3]*b_reg[3][2] + a_reg[7][4]*b_reg[4][2] + a_reg[7][5]*b_reg[5][2] + a_reg[7][6]*b_reg[6][2] + a_reg[7][7]*b_reg[7][2];
            c73 <= a_reg[7][0]*b_reg[0][3] + a_reg[7][1]*b_reg[1][3] + a_reg[7][2]*b_reg[2][3] + a_reg[7][3]*b_reg[3][3] + a_reg[7][4]*b_reg[4][3] + a_reg[7][5]*b_reg[5][3] + a_reg[7][6]*b_reg[6][3] + a_reg[7][7]*b_reg[7][3];
            c74 <= a_reg[7][0]*b_reg[0][4] + a_reg[7][1]*b_reg[1][4] + a_reg[7][2]*b_reg[2][4] + a_reg[7][3]*b_reg[3][4] + a_reg[7][4]*b_reg[4][4] + a_reg[7][5]*b_reg[5][4] + a_reg[7][6]*b_reg[6][4] + a_reg[7][7]*b_reg[7][4];
            c75 <= a_reg[7][0]*b_reg[0][5] + a_reg[7][1]*b_reg[1][5] + a_reg[7][2]*b_reg[2][5] + a_reg[7][3]*b_reg[3][5] + a_reg[7][4]*b_reg[4][5] + a_reg[7][5]*b_reg[5][5] + a_reg[7][6]*b_reg[6][5] + a_reg[7][7]*b_reg[7][5];
            c76 <= a_reg[7][0]*b_reg[0][6] + a_reg[7][1]*b_reg[1][6] + a_reg[7][2]*b_reg[2][6] + a_reg[7][3]*b_reg[3][6] + a_reg[7][4]*b_reg[4][6] + a_reg[7][5]*b_reg[5][6] + a_reg[7][6]*b_reg[6][6] + a_reg[7][7]*b_reg[7][6];
            c77 <= a_reg[7][0]*b_reg[0][7] + a_reg[7][1]*b_reg[1][7] + a_reg[7][2]*b_reg[2][7] + a_reg[7][3]*b_reg[3][7] + a_reg[7][4]*b_reg[4][7] + a_reg[7][5]*b_reg[5][7] + a_reg[7][6]*b_reg[6][7] + a_reg[7][7]*b_reg[7][7];
            
            state <= 2;
        end else if (state == 2) begin
            // Complete in cycle 2
            state <= 0;
            done <= 1;
        end
    end

endmodule