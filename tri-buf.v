module tri_buf(a,b,enable);

input [3:0] a;
output [3:0] reg b;
input enable;

always @(enable or a) begin
    if (enable) begin
        b = a;
    end else begin
        b = 1'bz; 
    end
end
endmodule