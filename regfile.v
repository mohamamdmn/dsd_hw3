module RegisterFile (
    input wire clk,
    input wire reset,                 // Active-high reset
    input wire write_enable,
    input wire [1:0] write_reg,      // Write address
    input wire  signed [15:0] write_data,     // Data to write

    input wire [1:0] read_reg1,      // Read address 1
    input wire [1:0] read_reg2,      // Read address 2
    output reg  signed [15:0] read_data1,     // Output data 1
    output reg signed  [15:0] read_data2      // Output data 2
);

    // Output wires from each register
    wire [15:0] registers [3:0];

    // Individual write enable signals for each register
    wire [3:0] reg_write_en;


    // Generate write enable signals based on selected write address
    assign reg_write_en[0] = write_enable & (write_reg == 2'b00);
    assign reg_write_en[1] = write_enable & (write_reg == 2'b01);
    assign reg_write_en[2] = write_enable & (write_reg == 2'b10);
    assign reg_write_en[3] = write_enable & (write_reg == 2'b11);

    // Instantiate 4 registers
    Register reg0 (.clk(clk), .reset(reset), .write_enable(reg_write_en[0]), .data_in(write_data), .data_out(registers[0]));
    Register reg1 (.clk(clk), .reset(reset), .write_enable(reg_write_en[1]), .data_in(write_data), .data_out(registers[1]));
    Register reg2 (.clk(clk), .reset(reset), .write_enable(reg_write_en[2]), .data_in(write_data), .data_out(registers[2]));
    Register reg3 (.clk(clk), .reset(reset), .write_enable(reg_write_en[3]), .data_in(write_data), .data_out(registers[3]));

    // Read on the falling edge of the clock
    always @(negedge clk) begin
            read_data1 <=  registers[read_reg1];
            read_data2 <=  registers[read_reg2];
        end

endmodule
