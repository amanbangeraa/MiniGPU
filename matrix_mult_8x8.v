// ==========================================================
// 8×8 Matrix Multiplier with 32-bit Interface
// Uses internal 8-bit MAC for efficiency but provides 
// 32-bit interface compatibility with existing system
// ==========================================================
module matrix_mult_8x8 (
    input clk,
    input rst,
    input start,
    // 32-bit interface for compatibility
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
    
    output [31:0] c00, c01, c02, c03, c04, c05, c06, c07,
    output [31:0] c10, c11, c12, c13, c14, c15, c16, c17,
    output [31:0] c20, c21, c22, c23, c24, c25, c26, c27,
    output [31:0] c30, c31, c32, c33, c34, c35, c36, c37,
    output [31:0] c40, c41, c42, c43, c44, c45, c46, c47,
    output [31:0] c50, c51, c52, c53, c54, c55, c56, c57,
    output [31:0] c60, c61, c62, c63, c64, c65, c66, c67,
    output [31:0] c70, c71, c72, c73, c74, c75, c76, c77,
    
    output done,
    output busy
);

    // Convert 32-bit inputs to 8-bit (saturate if needed)
    function [7:0] to_8bit;
        input [31:0] val;
        begin
            if (val > 127) 
                to_8bit = 8'sd127;
            else if (val < -128)
                to_8bit = 8'sd128;  // -128
            else
                to_8bit = val[7:0];
        end
    endfunction

    // Pack inputs into flat arrays for the core
    wire signed [511:0] A_flat;
    wire signed [511:0] B_flat;
    wire signed [1023:0] C_flat;
    
    // Pack matrix A (row-major order, MSB first)
    assign A_flat = {
        to_8bit(a00), to_8bit(a01), to_8bit(a02), to_8bit(a03), to_8bit(a04), to_8bit(a05), to_8bit(a06), to_8bit(a07),
        to_8bit(a10), to_8bit(a11), to_8bit(a12), to_8bit(a13), to_8bit(a14), to_8bit(a15), to_8bit(a16), to_8bit(a17),
        to_8bit(a20), to_8bit(a21), to_8bit(a22), to_8bit(a23), to_8bit(a24), to_8bit(a25), to_8bit(a26), to_8bit(a27),
        to_8bit(a30), to_8bit(a31), to_8bit(a32), to_8bit(a33), to_8bit(a34), to_8bit(a35), to_8bit(a36), to_8bit(a37),
        to_8bit(a40), to_8bit(a41), to_8bit(a42), to_8bit(a43), to_8bit(a44), to_8bit(a45), to_8bit(a46), to_8bit(a47),
        to_8bit(a50), to_8bit(a51), to_8bit(a52), to_8bit(a53), to_8bit(a54), to_8bit(a55), to_8bit(a56), to_8bit(a57),
        to_8bit(a60), to_8bit(a61), to_8bit(a62), to_8bit(a63), to_8bit(a64), to_8bit(a65), to_8bit(a66), to_8bit(a67),
        to_8bit(a70), to_8bit(a71), to_8bit(a72), to_8bit(a73), to_8bit(a74), to_8bit(a75), to_8bit(a76), to_8bit(a77)
    };
    
    // Pack matrix B (row-major order, MSB first)
    assign B_flat = {
        to_8bit(b00), to_8bit(b01), to_8bit(b02), to_8bit(b03), to_8bit(b04), to_8bit(b05), to_8bit(b06), to_8bit(b07),
        to_8bit(b10), to_8bit(b11), to_8bit(b12), to_8bit(b13), to_8bit(b14), to_8bit(b15), to_8bit(b16), to_8bit(b17),
        to_8bit(b20), to_8bit(b21), to_8bit(b22), to_8bit(b23), to_8bit(b24), to_8bit(b25), to_8bit(b26), to_8bit(b27),
        to_8bit(b30), to_8bit(b31), to_8bit(b32), to_8bit(b33), to_8bit(b34), to_8bit(b35), to_8bit(b36), to_8bit(b37),
        to_8bit(b40), to_8bit(b41), to_8bit(b42), to_8bit(b43), to_8bit(b44), to_8bit(b45), to_8bit(b46), to_8bit(b47),
        to_8bit(b50), to_8bit(b51), to_8bit(b52), to_8bit(b53), to_8bit(b54), to_8bit(b55), to_8bit(b56), to_8bit(b57),
        to_8bit(b60), to_8bit(b61), to_8bit(b62), to_8bit(b63), to_8bit(b64), to_8bit(b65), to_8bit(b66), to_8bit(b67),
        to_8bit(b70), to_8bit(b71), to_8bit(b72), to_8bit(b73), to_8bit(b74), to_8bit(b75), to_8bit(b76), to_8bit(b77)
    };

    // Instantiate the core 8x8 matrix multiplier
    matmul8x8_8bit_seq core_mult (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A_flat),
        .B(B_flat),
        .C(C_flat),
        .done(done)
    );

    assign busy = ~done;

    // Unpack results (16-bit to 32-bit, sign-extended)
    // Row 0
    assign c00 = $signed(C_flat[15:0]);
    assign c01 = $signed(C_flat[31:16]);
    assign c02 = $signed(C_flat[47:32]);
    assign c03 = $signed(C_flat[63:48]);
    assign c04 = $signed(C_flat[79:64]);
    assign c05 = $signed(C_flat[95:80]);
    assign c06 = $signed(C_flat[111:96]);
    assign c07 = $signed(C_flat[127:112]);
    
    // Row 1  
    assign c10 = $signed(C_flat[143:128]);
    assign c11 = $signed(C_flat[159:144]);
    assign c12 = $signed(C_flat[175:160]);
    assign c13 = $signed(C_flat[191:176]);
    assign c14 = $signed(C_flat[207:192]);
    assign c15 = $signed(C_flat[223:208]);
    assign c16 = $signed(C_flat[239:224]);
    assign c17 = $signed(C_flat[255:240]);
    
    // Row 2
    assign c20 = $signed(C_flat[271:256]);
    assign c21 = $signed(C_flat[287:272]);
    assign c22 = $signed(C_flat[303:288]);
    assign c23 = $signed(C_flat[319:304]);
    assign c24 = $signed(C_flat[335:320]);
    assign c25 = $signed(C_flat[351:336]);
    assign c26 = $signed(C_flat[367:352]);
    assign c27 = $signed(C_flat[383:368]);
    
    // Row 3
    assign c30 = $signed(C_flat[399:384]);
    assign c31 = $signed(C_flat[415:400]);
    assign c32 = $signed(C_flat[431:416]);
    assign c33 = $signed(C_flat[447:432]);
    assign c34 = $signed(C_flat[463:448]);
    assign c35 = $signed(C_flat[479:464]);
    assign c36 = $signed(C_flat[495:480]);
    assign c37 = $signed(C_flat[511:496]);
    
    // Row 4
    assign c40 = $signed(C_flat[527:512]);
    assign c41 = $signed(C_flat[543:528]);
    assign c42 = $signed(C_flat[559:544]);
    assign c43 = $signed(C_flat[575:560]);
    assign c44 = $signed(C_flat[591:576]);
    assign c45 = $signed(C_flat[607:592]);
    assign c46 = $signed(C_flat[623:608]);
    assign c47 = $signed(C_flat[639:624]);
    
    // Row 5
    assign c50 = $signed(C_flat[655:640]);
    assign c51 = $signed(C_flat[671:656]);
    assign c52 = $signed(C_flat[687:672]);
    assign c53 = $signed(C_flat[703:688]);
    assign c54 = $signed(C_flat[719:704]);
    assign c55 = $signed(C_flat[735:720]);
    assign c56 = $signed(C_flat[751:736]);
    assign c57 = $signed(C_flat[767:752]);
    
    // Row 6
    assign c60 = $signed(C_flat[783:768]);
    assign c61 = $signed(C_flat[799:784]);
    assign c62 = $signed(C_flat[815:800]);
    assign c63 = $signed(C_flat[831:816]);
    assign c64 = $signed(C_flat[847:832]);
    assign c65 = $signed(C_flat[863:848]);
    assign c66 = $signed(C_flat[879:864]);
    assign c67 = $signed(C_flat[895:880]);
    
    // Row 7
    assign c70 = $signed(C_flat[911:896]);
    assign c71 = $signed(C_flat[927:912]);
    assign c72 = $signed(C_flat[943:928]);
    assign c73 = $signed(C_flat[959:944]);
    assign c74 = $signed(C_flat[975:960]);
    assign c75 = $signed(C_flat[991:976]);
    assign c76 = $signed(C_flat[1007:992]);
    assign c77 = $signed(C_flat[1023:1008]);

endmodule