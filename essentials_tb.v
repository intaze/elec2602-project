`timescale 1ns / 1ps
 
module essentials_tb;
 
	reg clk;
    reg reset;
    reg [3:0] instruction;  // D_OUT GOES TO ALU
    reg [15:0] data_in;   // D_IN

    always #10 clk = ~clk;  // generate clock signals

    my_fsm fsm (
        .instruction(instruction),
        .a_in(data_in),
        .bus(16'h0000), 
        .g_out(),  
        .addsub()
    );

    initial begin
        clk = 0;
        reset = 1;
        instruction = 0;
        data_in = 0;
        #25 reset = 0;
    end

        always @(posedge clk) begin
            case(instruction)
                4'b0000: data_in <= 16'h0001; 
                4'b0001: data_in <= 16'h0002; 
                4'b0010: data_in <= 16'h0003;
                4'b0011: data_in <= 16'h0004;
                default: data_in <= 16'h0000; 
            endcase
        end





initial begin
	$dumpfile("essentials_tb.vcd");
	$dumpvars(0, essentials_tb);
	#500 $finish
end
 
endmodule
