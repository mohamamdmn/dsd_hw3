module ControlUnit(
    input wire clk,
    input wire reset,
    input [15:0] alu_out,
    input [15:0] memory_data_out,
    input wire alu_done,
    output reg [2:0] alu_op,
    output reg alu_start,
    output reg register_read,
    output reg register_write,
    output reg [15:0] register_file_data,
    output reg memory_read,
    output reg memory_write,
    output reg [15:0] memory_addr,
    output reg [15:0] sign_extended,
    output reg i_type,
    output reg [1:0] rs1, rs2, rd,
    output reg ready,
    output reg [15:0] pc
);

    // State definitions
    localparam FETCH   = 3'd0,
               ID      = 3'd1,
               EXECUTE = 3'd2,
               MEMORY  = 3'd3,
               WRITEBK = 3'd4;

    // Internal registers for state machine
    reg [2:0] state, next_state;
    reg [15:0] instr_reg;
    

    // ===================================================================
    //  SEQUENTIAL LOGIC BLOCK: Handles state transitions and registers
    //  Uses non-blocking assignments (<=) and is sensitive to clock edge.
    // ===================================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FETCH;
            pc <= 0;
            instr_reg <= 0;
        end else begin
            state <= next_state;
            
            // Latch the instruction in the ID state
            if (state == ID) begin
                instr_reg <= memory_data_out;
            end

            // Update PC only after a successful instruction cycle
            if (state == WRITEBK) begin
                pc <= pc + 1;
                alu_op <= 3'b000;
                alu_start <= 0;
                register_read <= 0;
                register_write <= 0;
                register_file_data <= 0;
                memory_read <= 0;
                memory_write <= 0;
                memory_addr <= 0;
                i_type <= 0;
                sign_extended <= 16'd0;
                rs1 <= 2'b00;
                rs2 <= 2'b00;
                rd <= 2'b00;
                ready <= 0;
            end
        end
    end

    // ===================================================================
    //  COMBINATIONAL LOGIC BLOCK: Generates control signals
    //  Uses blocking assignments (=) and is sensitive to any input change.
    // ===================================================================
    always @(*) begin
        // Default values for all control signals to avoid latches
        // next_state = state; // Default: stay in the same state

        case (state)
            FETCH: begin
                memory_read = 1;
                memory_addr = pc;
                next_state = ID;
            end

            ID: begin
                // Decode instruction from memory_data_out directly in this cycle
                // The instruction will be latched into instr_reg at the next clock edge
                case (memory_data_out[15:13])
                    // R-type instructions (ADD, SUB, MUL, DIV)
                    3'b000, 3'b001, 3'b010, 3'b011: begin
                        alu_op = memory_data_out[15:13];
                        rd = memory_data_out[12:11];
                        rs1 = memory_data_out[10:9];
                        rs2 = memory_data_out[8:7];
                        i_type = 0;
                        register_read = 1;
                    end
                    // LOAD/STORE instructions
                    3'b100, 3'b101: begin
                        alu_op = 3'b000; // Use ALU for address calculation (ADD)
                        rd = memory_data_out[12:11];  // Destination for LOAD, source for STORE data
                        rs1 = memory_data_out[10:9]; // Base address register
                        // For STORE, rs2 is not used for ALU, but rd is used to read data
                        rs2 = memory_data_out[8:7];
                        i_type = 1;
                        sign_extended <= {{7{memory_data_out[8]}}, memory_data_out[8:0]};
                        register_read = 1;
                    end
                    default: alu_op = 3'b000;
                endcase
                next_state = EXECUTE;
            end

            EXECUTE: begin
                alu_start = 1;
                // Wait for ALU to finish
                if (alu_done) begin
                     case (instr_reg[15:13])
                        3'b000, 3'b001, 3'b010, 3'b011: begin
                            next_state = WRITEBK;
                        end
                        3'b100, 3'b101: begin
                            next_state = MEMORY;
                        end
                        endcase
                end else begin
                    next_state = EXECUTE; // Stay in EXECUTE state if alu is not done
                end
            end

            MEMORY: begin
                // We use the latched instruction from instr_reg now
                case (instr_reg[15:13])
                    // LOAD: Use ALU result as memory address to read from
                    3'b100: begin
                        memory_addr = alu_out;
                        memory_read = 1;
                        next_state = WRITEBK;
                    end
                    // STORE: Use ALU result as address and write data to memory
                    3'b101: begin
                        memory_addr = alu_out;
                        memory_write = 1;
                        next_state = WRITEBK;
                    end
                    default: next_state = WRITEBK;
                endcase
            end

            WRITEBK: begin
                // For LOAD instruction, now write the data from memory to the register file
              case (instr_reg[15:13])
                            3'b000, 3'b001, 3'b010, 3'b011: begin // R-Type
                                register_file_data = alu_out;
                                register_write = 1;
                            end
                            3'b100: begin
                                register_file_data = memory_data_out; // Load
                                register_write  = 1;
                            end
                    endcase

                ready = 1; // Signal that the instruction is complete
                next_state = FETCH; // Go to next instruction
            end
        endcase
    end

endmodule
