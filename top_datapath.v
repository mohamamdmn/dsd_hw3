module Top(
    input wire clk,
    input wire reset
);






MainMemory memory(
    .clk(clk),
    .mem_read(),
    .mem_read(),
    .mem_write(),
    .address(),
    .write_data(),
    .read_data()
);






endmodule