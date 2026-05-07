module HA(a,b,cout,s);
	input a,b;
	output cout,s;

	assign {cout,s} = a + b;
	
endmodule