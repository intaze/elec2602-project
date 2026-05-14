module my_fsm (
    input rst,
    input clk,
    input [4:0] instruction,
    output reg [1:0] reg_en, //change number of bits depending on how many registers you have
    output reg [1:0] reg_tri, //change this too
    output reg a_en,
    output reg a_tri,
    output reg g_en,
    output reg g_tri,
    output reg addsub
);

    always @(*) begin
        reg_tri = 2'b00; // Tri-state register 0 to bus
        reg_en = 2'b00; // Enable register 0 to store value from bus
        a_en = 0;
        a_tri = 0;
        g_en = 0;
        g_tri = 0;
        addsub = 0; // Default to addition

        case (instruction)
            5'b00000: begin // load
                reg_en[0] = 1; // Enable register 0 to store value from bus
            end 

            5'b00001: begin // move
                reg_tri [0] = 1; // Tri-state register 0 to bus
                reg_en [1] = 1; // Enable register 1 to store value from bus
            end

            5'b00010: begin //add
                addsub = 1'b0; // Set addsub to 0 for addition
                g_en = 1'b1; // Enable register G to store result from ALU
                g_tri = 1'b1; // Tri-state register G to bus
                reg_en[0] = 1'b1;; // Enable register 0 to store value from bus
            end

            5'b00011: begin //subtract
                addsub = 1'b1; // Set addsub to 1 for subtraction
                g_en = 1'b1; // Enable register G to store result from ALU
                g_tri = 1'b1; // Tri-state register G to bus
                reg_en [0] = 2'b01; // Enable register 0 to store value from bus
            end

            default: begin
                reg_tri = 2'b00; // Tri-state register 0 to bus
                reg_en = 2'b00; // Enable register 0 to store value from bus
                a_en = 0;
                a_tri = 0;
                g_en = 0;
                g_tri = 0;
                addsub = 0; // Default to addition
            end
        endcase
    end
    
endmodule
