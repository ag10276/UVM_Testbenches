module barrel_shifter_8 (
    input  logic [7:0] x,
    input  logic [2:0] s,
    output logic [7:0] y
);

logic [7:0] a, b;

assign a = s[0] ? {1'b0, x[7:1]} : x;
assign b = s[1] ? {2'b00, a[7:2]} : a;
assign y = s[2] ? {4'b0000, b[7:4]} : b;

endmodule

interface bshifter8;
  logic [7:0] x;
  logic [2:0] s;
  logic [7:0] y;
endinterface