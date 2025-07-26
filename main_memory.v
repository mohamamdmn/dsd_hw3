module MainMemory (
    parameter ADDR_WIDTH = 16,              
    parameter DATA_WIDTH = 16              
    input clk,
    input mem_read,      
    input mem_write,    
    input  [ADDR_WIDTH-1:0]  address,
    input  [DATA_WIDTH-1:0]  write_data,
    output reg [DATA_WIDTH-1:0] read_data
);
 
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (mem_write)          
            mem[address] <= write_data;
              
        read_data <= mem[address];
    end
endmodule
