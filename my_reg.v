module my_reg (clk, bus, enable, data_out);

input clk;
input [15:0] bus;  // en=1 bus value is stored in reg, en=0
input enable;  // en=0 reg value is unchanged
output reg [15:0] data_out;  // output from reg

always @(posedge clk) begin
    if (enable) begin  // en=1
        data_out <= bus;
    end
end

endmodule