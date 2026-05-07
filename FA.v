module FA(a,b,cin,cout,s);
	input a,b,cin;
	wire cout,s;

	assign {cout,s} = a + b + cin;

endmodule