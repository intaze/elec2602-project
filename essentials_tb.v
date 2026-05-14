`timescale 1ns / 1ps


module essentials_tb;
    reg clk;
    reg reset;
    reg [3:0] instruction;   
    reg [15:0] data_in;     

    wire [15:0] g_out;       
    wire        addsub;      

    initial clk = 0;
    always  #10 clk = ~clk;

    my_fsm dut (
        .instruction(instruction),
        .a_in(data_in),
        .bus(16'h0000),  
        .g_out(g_out),
        .addsub(addsub)
    );

    task apply_instr;
        input [1:0] opcode;
        input [1:0] dest;
        input [15:0] imm_src;
        input [63:0] label;      
        begin
            @(negedge clk);       
            instruction = {opcode, dest};
            data_in     = imm_src;
            @(posedge clk); #1;   
            @(posedge clk); #1;    
            $display("[%0t ns]  %s | instr=%b  data_in=0x%04h | g_out=0x%04h  addsub=%b",
                     $time, label, instruction, data_in, g_out, addsub);
        end
    endtask

    initial begin
        reset       = 1;
        instruction = 4'b0000;
        data_in     = 16'h0000;

        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;
        $display("=== Reset released at %0t ns ===", $time);

        // TEST 1 – LDI R0, 0x000A   (R0 = 10)
        $display("\n--- LDI tests ---");
        apply_instr(2'b00, 2'b00, 16'h000A, "LDI_R0 ");

        // TEST 2 – LDI R1, 0x0005   (R1 = 5)
        apply_instr(2'b00, 2'b01, 16'h0005, "LDI_R1 ");

        // TEST 3 – LDI R2, 0x0003   (R2 = 3)
        apply_instr(2'b00, 2'b10, 16'h0003, "LDI_R2 ");

        // TEST 4 – MOV R2, R0 (R2 = R0 = 10) - data_in[1:0] encodes the source register index (R0 = 0)
        $display("\n--- MOV test ---");
        apply_instr(2'b01, 2'b10, 16'h0000, "MOV_R2 ");

        // TEST 5 – ADD R0, R1       (R0 = R0 + R1 = 10 + 5 = 15)
        $display("\n--- ADD test ---");
        apply_instr(2'b10, 2'b00, 16'h0001, "ADD_R0 ");

        // TEST 6 – SUB R0, R2       (R0 = R0 - R2 = 15 - 10 = 5)
        $display("\n--- SUB test ---");
        apply_instr(2'b11, 2'b00, 16'h0002, "SUB_R0 ");

        // TEST 7 – ADD R1, R2       (R1 = R1 + R2 = 5 + 10 = 15)
        apply_instr(2'b10, 2'b01, 16'h0002, "ADD_R1 ");

        // TEST 8 – SUB R2, R1       (R2 = R2 - R1 = 10 - 15 = -5)
        apply_instr(2'b11, 2'b10, 16'h0001, "SUB_R2 ");

        // TEST 9 – LDI R0, 0x0000   (R0 = 0, boundary / zero test)
        $display("\n--- Edge-case tests ---");
        apply_instr(2'b00, 2'b00, 16'h0000, "LDI_R0Z");

        // TEST 10 – ADD R0, R1      (0 + 15 = 15, add-to-zero)
        apply_instr(2'b10, 2'b00, 16'h0001, "ADD_0+R1");

        // TEST 11 – SUB R0, R0      (R0 - R0 = 0, self-subtract)
        apply_instr(2'b11, 2'b00, 16'h0000, "SUB_R0R0");

        repeat(4) @(posedge clk);
        $display("\n=== Simulation complete at %0t ns ===", $time);
        $finish;
    end

    initial begin
        $dumpfile("essentials_tb.vcd");
        $dumpvars(0, essentials_tb);
    end

endmodule
