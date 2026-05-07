`timescale 1ns / 1ps
module lab4_p3_TB(a,b,cin,cout,s);

	reg [3:0] a,b;
	reg cin;
	reg [5:0] s;
	reg cout;
	
	//instantiate and connect fourBit_FA
	
	fourBit_FA a1(.a(a), .b(b), .cin(cin), .s(S), .cout(cout));

 	
	initial begin 
		count = 4'b0000;
	end
	
	always begin
		#50
		count=count+4'b0001;
	end

	initial begin
		$dumpfile("lab4_p3_TB.vcd");
    	$dumpvars(0, lab4_p3_TB);
		#500;
		$finish;
	end

	
	always @(count) begin
        case (count)
            // a=0, b=0, cin=0 => 0+0+0 = 0  => cout=0, s=0000
            4'b0000: begin a = 4'b0000; b = 4'b0000; cin = 1'b0; end
 
            // a=0, b=0, cin=1 => 0+0+1 = 1  => cout=0, s=0001
            4'b0001: begin a = 4'b0000; b = 4'b0000; cin = 1'b1; end
 
            // a=1, b=0, cin=0 => 1+0+0 = 1  => cout=0, s=0001
            4'b0010: begin a = 4'b0001; b = 4'b0000; cin = 1'b0; end
 
            // a=1, b=1, cin=0 => 1+1+0 = 2  => cout=0, s=0010
            4'b0011: begin a = 4'b0001; b = 4'b0001; cin = 1'b0; end
 
            // a=1, b=1, cin=1 => 1+1+1 = 3  => cout=0, s=0011
            4'b0100: begin a = 4'b0001; b = 4'b0001; cin = 1'b1; end
 
            // a=7, b=8, cin=0 => 7+8+0 = 15 => cout=0, s=1111
            4'b0101: begin a = 4'b0111; b = 4'b1000; cin = 1'b0; end
 
            // a=8, b=8, cin=0 => 8+8+0 = 16 => cout=1, s=0000
            4'b0110: begin a = 4'b1000; b = 4'b1000; cin = 1'b0; end
 
            // a=15, b=1, cin=0 => 15+1+0 = 16 => cout=1, s=0000
            4'b0111: begin a = 4'b1111; b = 4'b0001; cin = 1'b0; end
 
            // a=15, b=15, cin=1 => 15+15+1 = 31 => cout=1, s=1111
            4'b1000: begin a = 4'b1111; b = 4'b1111; cin = 1'b1; end
 
            // a=9, b=6, cin=1 => 9+6+1 = 16 => cout=1, s=0000
            4'b1001: begin a = 4'b1001; b = 4'b0110; cin = 1'b1; end
 
            default: begin a = 4'b0000; b = 4'b0000; cin = 1'b0; end
        endcase
    end
	
endmodule