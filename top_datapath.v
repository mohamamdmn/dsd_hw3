module Top(
    input wire clk,
    input wire reset
);

    // ================== Wires for interconnection ==================
    // Control Signals
    wire [2:0]  cu_alu_op;
    wire  cu_alu_start;
    wire  cu_reg_read;
    wire  cu_reg_write;
    wire  cu_mem_read;
    wire  cu_mem_write;
    wire  cu_ready;
    
    // Address/Data buses
    wire [15:0] cu_pc;
    wire [1:0]  cu_rs1, cu_rs2, cu_rd;
    wire  signed [15:0] cu_reg_file_data_in; // Data to be written into RegFile
    wire  [15:0] cu_mem_addr;
    wire [15:0] cu_mem_data_in;    // Data to be written into Memory

    // Data outputs from modules
    wire  signed [15:0] rf_read_data1, rf_read_data2;
    wire [15:0] mem_read_data;
    wire signed[15:0] alu_result_out;
    wire   alu_done_out;
    wire i_type;
    wire signed [15:0] b_final;
    wire  signed [15:0] sign_extended;
    wire [1:0] read_reg_source2_real;

    assign b_final = i_type ? sign_extended : rf_read_data2;
    assign read_reg_source2_real = i_type ? cu_rd : cu_rs2;





    // ================== Component Instantiation ==================

    // 1. Control Unit - The Brain
    ControlUnit control_unit (
        .clk(clk),
        .reset(reset),
        .alu_out(alu_result_out),
        .memory_data_out(mem_read_data),
        .alu_done(alu_done_out),
        .alu_op(cu_alu_op),
        .alu_start(cu_alu_start),
        .register_read(cu_reg_read), // This signal is internal to CU now
        .register_write(cu_reg_write),
        .register_file_data(cu_reg_file_data_in), // Data selected to be written
        .memory_read(cu_mem_read),
        .memory_write(cu_mem_write),
        .memory_addr(cu_mem_addr),
        .sign_extended(sign_extended),
        .i_type(i_type),
        .rs1(cu_rs1),
        .rs2(cu_rs2),
        .rd(cu_rd),
        .ready(cu_ready),
        .pc(cu_pc)
    );

    // 2. Register File - Stores processor state
    RegisterFile register_file(
        .clk(clk),
        .reset(reset),
        .write_enable(cu_reg_write),
        .read_reg1(cu_rs1),
        .read_reg2(read_reg_source2_real),
        .write_reg(cu_rd),
        .write_data(cu_reg_file_data_in), // Data comes from CU's selection
        .read_data1(rf_read_data1),
        .read_data2(rf_read_data2)
    );

    // 3. Main Memory - Stores instructions and data
    MainMemory memory(
        .clk(clk),
        .mem_read(cu_mem_read),
        .mem_write(cu_mem_write),
        .address(cu_mem_addr),
        .write_data(rf_read_data2), // For STORE, data comes from RegFile's second port
        .read_data(mem_read_data)
    );

    // 4. ALU - Performs arithmetic/logic operations
    ALU alu(
        .clk(clk),
        .rst(reset),
        .a(rf_read_data1),
        .b(b_final),
        .start(cu_alu_start),
        .alu_op(cu_alu_op),
        .alu_out(alu_result_out),
        .done(alu_done_out)
    );
    
endmodule
