module tri_buf(a,bus,enable);

input [15:0] a;
output [15:0] b;
input enable;

assign b = enable ? a : 16'bz;

endmodule