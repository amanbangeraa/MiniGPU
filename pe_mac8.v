module pe_mac8(
    input clk,
    input clear,
    input valid,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [15:0] c
);

    always @(posedge clk) begin
        if (clear)
            c <= 16'd0;
        else if (valid)
            c <= c + (a * b);
    end

endmodule