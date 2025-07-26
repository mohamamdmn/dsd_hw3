module RestoringDivider16 (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [15:0] numerator,
    input wire [15:0] denominator,
    output reg [15:0] quotient,
    output reg done
);
    reg [4:0] bit_index;
    reg [31:0] remainder_reg;
    reg [15:0] denominator_abs;
    reg [15:0] quotient_next;
    reg sign_numerator, sign_denominator;

    reg in_progress;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 0;
            remainder_reg <= 0;
            quotient_next <= 0;
            denominator_abs <= 0;
            bit_index <= 0;
            done <= 0;
            in_progress <= 0;
        end else begin
            if (start && !in_progress) begin
                in_progress <= 1;
                done <= 0;
                bit_index <= 0;

                sign_numerator <= numerator[15];
                sign_denominator <= denominator[15];

                remainder_reg <= {16'b0, numerator[15] ? (~numerator + 1) : numerator};
                denominator_abs <= denominator[15] ? (~denominator + 1) : denominator;
                quotient_next <= 0;
            end else if (in_progress) begin
                if (bit_index < 16) begin
                    remainder_reg = {remainder_reg[30:0], 1'b0}; // Shift left
                    remainder_reg[15:0] = remainder_reg[15:0] - denominator_abs;

                    if (remainder_reg[15]) begin
                        remainder_reg[15:0] = remainder_reg[15:0] + denominator_abs; // Restore
                        quotient_next = quotient_next << 1;
                    end else begin
                        quotient_next = (quotient_next << 1) | 1'b1;
                    end
                    bit_index = bit_index + 1;
                end else begin
                    // Adjust sign
                    if (sign_numerator ^ sign_denominator)
                        quotient <= ~quotient_next + 1;
                    else
                        quotient <= quotient_next;

                    done <= 1;
                    in_progress <= 0;
                end
            end else begin
                done <= 0;
            end
        end
    end
endmodule
