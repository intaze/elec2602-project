module my_alu (a,bus,addsub,g);
    input [15:0] a;
    input [15:0] bus;
    input addsub;
    output reg [15:0] g;

    always @(*) begin
        if (addsub==1'b1) begin
            g = a + bus;
        end 
        else begin
            g = a - bus;
        end
    end
endmodule