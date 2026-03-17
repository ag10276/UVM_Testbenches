module full_adder(
  input logic a, b, cin,
  output logic sum, cout
);
  
  always_comb begin
    {cout, sum} = a + b + cin;
  end
endmodule

module adder(
  input logic [3:0] a, b,
  input logic cin,
  output logic [3:0] sum, 
  output logic cout
);
  
  logic cin2, cin3, cin4;
  
  full_adder fa1(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cin2));
  full_adder fa2(.a(a[1]), .b(b[1]), .cin(cin2), .sum(sum[1]), .cout(cin3));
  full_adder fa3(.a(a[2]), .b(b[2]), .cin(cin3), .sum(sum[2]), .cout(cin4));
  full_adder fa4(.a(a[3]), .b(b[3]), .cin(cin4), .sum(sum[3]), .cout(cout));
  
endmodule

interface adder_if;
  logic [3:0] a;
  logic [3:0] b;
  logic cin;
  logic [3:0] sum;
  logic cout;
endinterface