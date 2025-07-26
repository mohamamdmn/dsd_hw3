module ShiftAndAddMultiplier(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] multiplicand,
    input wire [7:0] multiplier,
    output reg [15:0] product,
    output reg done
);

reg [7:0] mcand;      
reg [7:0] mplier;     
reg [3:0] count;      
reg busy;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product <= 0;
        mcand <= 0;
        mplier <= 0;
        count <= 0;
        busy <= 0;
        done <= 0;
    end else begin
        if (start && !busy) begin
            mcand <= multiplicand;
            mplier <= multiplier;
            product <= 0;
            count <= 0;
            busy <= 1;
            done <= 0;
        end else if (busy) begin
            if (mplier[0] == 1) begin
                product <= product + (mcand << count);
            end
            mplier <= mplier >> 1;
            count <= count + 1;
            if (count == 7) begin
                busy <= 0;
                done <= 1;
            end
        end else begin
            done <= 0; 
        end
    end
end

endmodule
