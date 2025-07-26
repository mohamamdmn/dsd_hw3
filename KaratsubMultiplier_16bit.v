module KaratsubMultiplier_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] answer,
    output reg done

);

wire [7:0] z0, z1, z2;
wire done0,done1,done2;


wire [7:0] a_l = a[7:0];
wire [7:0] a_h = a[15:8];
wire [7:0] b_l = b[7:0];
wire [7:0] b_h = b[15:8];
wire [7:0] sum_l = a_l + b_l;
wire [7:0] sum_h = a_h + b_h;



ShiftAddMultiplier8 shiftaddmultiplier0(clk,rst_n,start,a_l,b_l,z0,done0);
ShiftAddMultiplier8 shiftaddmultiplier1(clk,rst_n,start,sum_l,sum_h,z1,done1);
ShiftAddMultiplier8 shiftaddmultiplier2(clk,rst_n,start,a_h,b_h,z2,done2);

reg [15:0] z1_complete;



    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            answer <= 0;
            done <= 0;
        end else begin
            if (start && done && done1 && done2)begin
                z1_complete <= z1 - z0 - z2;
                answer <= z0 + (z1_complete << 8);  // z2 shifted 16 bits gets ignored (result limited to 16 bits)
                done <= 1;
            end else
                done <= 0;
        end
    end
endmodule

