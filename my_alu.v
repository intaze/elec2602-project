module my_alu (a,bus,addsub,g);
    input [3:0] a;
    input [3:0] bus;
    input addsub;
    output reg [3:0] g;

    always @(*) begin
        if (addsub==1'b1) begin
            g = a + bus;
        end 
        else begin
            g = a - bus;
        end
    end
endmodule