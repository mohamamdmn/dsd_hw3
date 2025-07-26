`timescale 1ns/1ps

module Processor_TB;

    reg clk = 0;
    reg reset = 0;
    wire ready;
    wire [15:0] pc_out;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .rst(reset),
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        reset = 1;          // Reset initially active
        #10 reset = 0;


        uut.memory.mem[16] = 16'b000_00_00_000000011;
        uut.memory.mem[17] = 16'b000_00_00_000000101;

        // Initialize instruction memory

        // Load x0, 0
        uut.memory.mem[0] = 16'b100_00_00_000010000; // load x0, 0
        // Load x1, 1
        uut.memory.mem[1] = 16'b100_01_00_000010001; // load x1, 1

        uut.memory.mem[2] = 16'b000_10_00_01_0010001; // load x1, 1

        
        #500;

        $stop();
    end

    always @(posedge clk) begin
        // Display register contents
        $display("Register x0: %d", uut.register_file.registers[0]);
        $display("Register x1: %d",  uut.register_file.registers[1]);
        $display("Register x2: %d",  uut.register_file.registers[2]);
        $display("Register x3: %d", uut.register_file.registers[3]);
        $display("memory: %d", uut.memory.mem[16]);
        // $display("pc: %d", uut.pc_out);
        // $display("instr: %d", uut.instr);
        // $display("mem_out: %d", uut.mem_data_out);
        // $display("mem_read: %d", uut.ctrl.mem_read);
        // $display("state: %d", uut.ctrl.state);
        // $display("alu_out: %d", uut.alu_inst.result);
        // $display("alu_1: %d", uut.alu_inst.a);
        // $display("alu_2: %d", uut.alu_inst.b);
        // $display("immediate_sel: %d", uut.immediate_sel);
        // $display("sign_extended: %d", uut.sign_extended);
        // $display("rf_data_rs1: %d", uut.rf_data_rs1);
        // $display("rf_data_rs2: %d", uut.rf_data_rs2);
        // $display("---------------------------------------------");
    end

endmodule
