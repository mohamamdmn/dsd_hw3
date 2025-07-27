module ALU (
    input wire clk,
    input wire rst,
    input  wire signed [15:0] a,
    input  wire  signed[15:0] b,
    input wire start,
    input wire [2:0] alu_op,
    output reg signed  [15:0] alu_out,
    output reg done
);

//Add and subtract
wire  signed [15:0] b_complete = ~b + 1;
wire  signed [15:0] b_final;
assign b_final = (alu_op == 2'b001) ? b_complete : b ;
wire carry;
wire signed [15:0] add_sub_result;
carry_select_adder csa(
    .a(a),
    .b(b_final),
    .carry_in(1'b0),
    .sum(add_sub_result),
    .carry_out(carry)
);


always@(posedge clk,posedge rst)begin
    if(rst)begin
        alu_out <= 0;
        done <= 0;
    end
    else begin
        done <= 0;
        if(start)begin
            alu_out <= add_sub_result;
            done <= 1;
        end
    end


end






endmodule
