module comparator(
  input logic [1:0] a, 
  input logic [1:0] b,
  output logic agreaterb,
  output logic aequalb, 
  output logic alesserb
);
  
  always_comb begin
    if(a > b) begin
      agreaterb = 1'b1;
      aequalb = 1'b0;
      alesserb = 1'b0;
    end else if (a < b) begin
      agreaterb = 1'b0;
      aequalb = 1'b0;
      alesserb = 1'b1;
    end else begin
      agreaterb = 1'b0;
      aequalb = 1'b1;
      alesserb = 1'b0;
    end
  end  
endmodule

interface comp_if;
  logic [1:0] a;
  logic [1:0] b;
  logic agreaterb;
  logic aequalb;
  logic alesserb;
endinterface