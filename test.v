`timescale 1ns/1ps

module Processor_TB;

    reg clk = 0;
    reg reset = 0;
    wire ready;
    wire [15:0] pc_out;

    // Instantiate the top module
    Top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        reset = 1;          // Reset initially active
        #10 reset = 0;


        uut.memory.mem[16] = 16'b000_00_00_000000100;  //mem[16] = 4
        uut.memory.mem[17] = 16'b000_00_00_000000110;  //mem[17] = 6

        // Initialize instruction memory

        // Load x0, mem[16]
        uut.memory.mem[0] = 16'b100_00_00_000010000; 
        // Load x1, mem[17]
        uut.memory.mem[1] = 16'b100_01_00_000010001; 

        //add x2 x1 x0 
        uut.memory.mem[2] = 16'b000_10_00_01_0010001; 

        //stoer 
        uut.memory.mem[2] = 16'b101_00_00_000010000;


        
        #500;

        $stop();
    end

    always @(posedge clk) begin
        // Display register contents
        $display("Register x0: %d", uut.register_file.reg0.data_out);
        $display("Register x1: %d", uut.register_file.reg1.data_out);
        $display("Register x2: %d", uut.register_file.reg2.data_out);
        $display("Register x3: %d", uut.register_file.reg3.data_out);
        $display("memory: %d", uut.memory.mem[16]);
        $display("pc: %d", uut.cu_pc);
        $display("mem_out: %b", uut.mem_read_data);
        // $display("mem_read: %d", uut.ctrl.mem_read);
        $display("state: %d", uut.control_unit.state);
        $display("alu_out: %d", uut.alu.alu_out);
        $display("alu_1: %d", uut.alu.a);
        $display("alu_2: %d", uut.alu.b);
        $display("immediate_sel: %d", uut.i_type);
        $display("sign_extended: %d", uut.sign_extended);
        $display("reg_write_enable: %d", uut.register_file.write_enable);
        $display("rf_rs1: %d", uut.cu_rs1);
        $display("rf_rs2: %d", uut.cu_rs2);
        $display("rf_rd: %d", uut.cu_rd);
        $display("rf_data_rs1: %d", uut.rf_read_data1);
        $display("rf_data_rs2: %d", uut.rf_read_data2);
        $display("---------------------------------------------");
    end

endmodule
