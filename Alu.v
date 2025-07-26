module ALU (
    input wire clk,
    input wire rst,
    input wire [15:0] a,
    input wire [15:0] b,
    input wire start,
    input wire [1:0] alo_op,
    output reg [15:0] alu_out,
    output reg done
);

//Add and subtract
wire [15:0] b_complete = ~b + 1;
wire [15:0] b_final;
assign b_final = (alo_op == 2'b01) ? b_complete : b ;
wire carry;
wire [15:0] add_sub_result;
carry_select_adder csa(
    .a(a),
    .b(b_final),
    .carry_in(1'b0),
    .sum(add_sub_result),
    .carry_out(carry)
);


always@(posedge clk,posedge rst)begin
    if(rst)begin
        result <= 0;
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