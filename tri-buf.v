module tri_buf(
    input [15:0] a,
    output [15:0] bus,
    input enable
);

    assign bus = enable ? a : 16'bz;

endmodule