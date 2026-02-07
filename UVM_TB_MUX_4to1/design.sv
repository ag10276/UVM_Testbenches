module mux4to1(
  input logic [3:0] in0, in1, in2, in3,
  input logic [1:0] sel,
  output logic [3:0]out
);
  
  always_comb begin
    case(sel)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = in3;
      default: out = 0;
    endcase
  end
  
endmodule

interface mux_if; 
  logic [3:0] in0; 
  logic [3:0] in1; 
  logic [3:0] in2; 
  logic [3:0] in3; 
  logic [1:0] sel; 
  logic [3:0] out; 
endinterface
  