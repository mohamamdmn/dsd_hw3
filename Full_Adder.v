module FullAdder(
    input  a,         
    input b,   
    input carry_in,  
    output carry_out,
    output sum      
);

wire a_xor_b;        
wire ab_and;         
wire xor_cin_and;   

xor(a_xor_b, a, b);
xor(sum, a_xor_b, carry_in);

and(ab_and, a, b);
and(xor_cin_and, a_xor_b, carry_in);
or(carry_out, ab_and, xor_cin_and);

endmodule
