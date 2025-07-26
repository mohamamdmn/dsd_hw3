module carry_select_adder(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire carry_in,
    output wire [15:0] sum,
    output wire carry_out
);

    wire [15:0] sum0_flat, sum1_flat;
    wire [3:0] cout0, cout1;
    wire [4:0] carry;

    assign carry[0] = carry_in;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : csa_blocks
            RippleCarryAdder_4bit adder0_i (
                .a(a[i*4 +: 4]),
                .b(b[i*4 +: 4]),
                .carry_in(1'b0),
                .sum(sum0_flat[i*4 +: 4]),
                .carry_out(cout0[i])
            );

            RippleCarryAdder_4bit adder1_i (
                .a(a[i*4 +: 4]),
                .b(b[i*4 +: 4]),
                .carry_in(1'b1),
                .sum(sum1_flat[i*4 +: 4]),
                .carry_out(cout1[i])
            );

            assign sum[i*4 +: 4]   = carry[i] ? sum1_flat[i*4 +: 4] : sum0_flat[i*4 +: 4];
            assign carry[i+1]      = carry[i] ? cout1[i] : cout0[i];
        end
    endgenerate

    assign carry_out = carry[4];

endmodule
