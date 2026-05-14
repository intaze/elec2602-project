module top (
    input clk,
    input rst,
    input [4:0] instruction,
    input [15:0] data_in, 
    output [15:0] bus_out 
);

    wire [15:0] bus;          
    wire [15:0] alu_result;  
    assign bus_out = bus; 

    wire [2:0] reg_en, reg_tri; 
    wire a_en, g_en, g_tri, addsub;

    wire [15:0] r0_out, r1_out, r2_out, a_reg_out, g_reg_out;


    my_fsm controller (
        .rst(rst),
        .clk(clk),
        .instruction(instruction),
        .reg_en(reg_en),
        .reg_tri(reg_tri),
        .a_en(a_en),
        .g_en(g_en),
        .g_tri(g_tri),
        .addsub(addsub)
    );


    my_reg R0 (.clk(clk), .bus(bus), .enable(reg_en[0]), .data_out(r0_out));
    my_reg R1 (.clk(clk), .bus(bus), .enable(reg_en[1]), .data_out(r1_out));
    my_reg R2 (.clk(clk), .bus(bus), .enable(reg_en[2]), .data_out(r2_out));


    my_reg A_REG (.clk(clk), .bus(bus), .enable(a_en), .data_out(a_reg_out));
    my_alu alu_inst (
        .a_in(a_reg_out), 
        .bus(bus), 
        .addsub(addsub), 
        .g_out(alu_result)
    );

    my_reg G_REG (.clk(clk), .bus(alu_result), .enable(g_en), .data_out(g_reg_out));


    tri_buf tri_r0 (.a(r0_out), .bus(bus), .enable(reg_tri[0]));
    tri_buf tri_r1 (.a(r1_out), .bus(bus), .enable(reg_tri[1]));
    tri_buf tri_r2 (.a(r2_out), .bus(bus), .enable(reg_tri[2]));

    tri_buf tri_g  (.a(g_reg_out), .bus(bus), .enable(g_tri));

    wire ldi_enable = (instruction == 5'b00000);
    tri_buf tri_ext (.a(data_in), .bus(bus), .enable(ldi_enable));

endmodule