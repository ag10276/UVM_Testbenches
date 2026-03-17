  
module mux4to1_sva (
  input logic [3:0] in0, in1, in2, in3,
  input logic [1:0] sel,
  input logic [3:0] out
);

  // Functional correctness
  always_comb begin
    case (sel)
      2'b00: SEL00: assert final (out == in0) else
               $error("[SVA] sel=00: out=%0h, expected in0=%0h", out, in0);
      2'b01: SEL01: assert final (out == in1) else
               $error("[SVA] sel=01: out=%0h, expected in1=%0h", out, in1);
      2'b10: SEL10: assert final (out == in2) else
               $error("[SVA] sel=10: out=%0h, expected in2=%0h", out, in2);
      2'b11: SEL11: assert final (out == in3) else
               $error("[SVA] sel=11: out=%0h, expected in3=%0h", out, in3);
    endcase
  end

  // Output must always be one of the four inputs
  always_comb begin
    OUT_VALID: assert final(
      (out == in0) || (out == in1) ||
      (out == in2) || (out == in3)
    ) else $error("[SVA] out=%0h does not match any input", out);
  end

  // No X/Z on output or select
  always_comb begin
    NO_X_OUT: assert (!$isunknown(out)) else
      $error("[SVA] X/Z on out");
    NO_X_SEL: assert (!$isunknown(sel)) else
      $error("[SVA] X/Z on sel");
  end

endmodule

bind mux4to1 mux4to1_sva u_sva (
  .in0 (in0),
  .in1 (in1),
  .in2 (in2),
  .in3 (in3),
  .sel (sel),
  .out (out)
);

