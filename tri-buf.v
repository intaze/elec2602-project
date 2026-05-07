module tri_buf(a,b,enable);

input [15:0] a;
output [15:0] reg b;
input enable;

always @(enable or a) begin
    if (enable) begin
        b = a;
    end else begin
        b = 1'bz; 
    end
end
endmodule