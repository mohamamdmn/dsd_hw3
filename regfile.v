module RegisterFile(
    input wire clk,
    input wire write_enable,
    input wire [1:0] read_reg1,    
    input wire [1:0] read_reg2,   
    input wire [1:0] write_reg,    
    input wire [15:0] write_data,  
    output reg [15:0] read_data1,  
    output reg [15:0] read_data2   
);

    reg [15:0] registers [3:0]; 

    always @(posedge clk) begin
        if (write_enable) begin
            registers[write_reg] <= write_data;
        end
    end

    always @(negedge clk) begin
        read_data1 <= registers[read_reg1];
        read_data2 <= registers[read_reg2];
    end

endmodule
