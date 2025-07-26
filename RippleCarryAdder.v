module RippleCarryAdder_4bit(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire carry_in,
    output wire [3:0] sum,
    output wire carry_out
);

wire [2:0] carries;

FullAdder fa0(a[0], b[0], carry_in,   carries[0], sum[0]);
FullAdder fa1(a[1], b[1], carries[0], carries[1], sum[1]);
FullAdder fa2(a[2], b[2], carries[1], carries[2], sum[2]);
FullAdder fa3(a[3], b[3], carries[2], carry_out,  sum[3]);

endmodule
