module alu_sva (
  input logic [7:0] a,
  input logic [7:0] b,
  input logic [7:0] y,
  input logic [2:0] opcode,
  input logic [3:0] flags
);

  logic sign_flag, carry_flag, zero_flag, overflow_flag;
  assign sign_flag     = flags[0];
  assign carry_flag    = flags[1];
  assign zero_flag     = flags[2];
  assign overflow_flag = flags[3];

  always_comb begin
    if (opcode == 3'b000) begin
      ADD_RESULT: assert final (y == a + b) else
        $error("[SVA-ADD] a=%0d b=%0d | got y=%0d | exp=%0d", a, b, y, a+b);

      ADD_CARRY: assert final (carry_flag == (({1'b0,a} + {1'b0,b}) > 9'h0FF)) else
        $error("[SVA-ADD] carry_flag=%b incorrect for a=%0d b=%0d", carry_flag, a, b);

      ADD_OVERFLOW: assert final (overflow_flag ==
        ((~a[7] & ~b[7] & y[7]) | (a[7] & b[7] & ~y[7]))) else
        $error("[SVA-ADD] overflow_flag=%b incorrect for a=%0d b=%0d y=%0d",
                overflow_flag, a, b, y);
    end
  end

  always_comb begin
    if (opcode == 3'b001) begin
      SUB_RESULT: assert final (y == a - b) else
        $error("[SVA-SUB] a=%0d b=%0d | got y=%0d | exp=%0d", a, b, y, a-b);

      SUB_CARRY: assert final (carry_flag == (a >= b)) else
        $error("[SVA-SUB] carry_flag=%b incorrect for a=%0d b=%0d", carry_flag, a, b);

      SUB_OVERFLOW: assert final (overflow_flag ==
        ((a[7] & ~b[7] & ~y[7]) | (~a[7] & b[7] & y[7]))) else
        $error("[SVA-SUB] overflow_flag=%b incorrect for a=%0d b=%0d y=%0d",
                overflow_flag, a, b, y);
    end
  end

  always_comb begin
    if (opcode == 3'b010)
      AND_RESULT: assert final (y == (a & b)) else
        $error("[SVA-AND] a=%08b b=%08b | got y=%08b | exp=%08b", a, b, y, a&b);
  end

  always_comb begin
    if (opcode == 3'b011)
      OR_RESULT: assert final (y == (a | b)) else
        $error("[SVA-OR] a=%08b b=%08b | got y=%08b | exp=%08b", a, b, y, a|b);
  end

  always_comb begin
    if (opcode == 3'b100)
      XOR_RESULT: assert final (y == (a ^ b)) else
        $error("[SVA-XOR] a=%08b b=%08b | got y=%08b | exp=%08b", a, b, y, a^b);
  end

  always_comb begin
    if (opcode == 3'b101)
      NOT_RESULT: assert final (y == ~a) else
        $error("[SVA-NOT] a=%08b | got y=%08b | exp=%08b", a, y, ~a);
  end

  always_comb begin
    if (opcode == 3'b110) begin
      SHL_RESULT: assert final (y == (a << 1)) else
        $error("[SVA-SHL] a=%08b | got y=%08b | exp=%08b", a, y, a<<1);

      SHL_CARRY: assert final (carry_flag == a[7]) else
        $error("[SVA-SHL] carry_flag=%b should be a[7]=%b", carry_flag, a[7]);
    end
  end

  always_comb begin
    if (opcode == 3'b111) begin
      SHR_RESULT: assert final (y == (a >> 1)) else
        $error("[SVA-SHR] a=%08b | got y=%08b | exp=%08b", a, y, a>>1);

      SHR_CARRY: assert final (carry_flag == a[0]) else
        $error("[SVA-SHR] carry_flag=%b should be a[0]=%b", carry_flag, a[0]);
    end
  end

  always_comb begin
    // Sign flag always tracks MSB of result
    SIGN_FLAG: assert final (sign_flag == y[7]) else
      $error("[SVA-FLAG] sign_flag=%b but y[7]=%b", sign_flag, y[7]);

    // Zero flag always set when result is zero
    ZERO_FLAG: assert final (zero_flag == (y == 8'b0)) else
      $error("[SVA-FLAG] zero_flag=%b but y=%08b", zero_flag, y);
  end

  always_comb begin
    NO_X_A:      assert final (!$isunknown(a))      else $error("[SVA] X/Z on a");
    NO_X_B:      assert final (!$isunknown(b))      else $error("[SVA] X/Z on b");
    NO_X_OPCODE: assert final (!$isunknown(opcode)) else $error("[SVA] X/Z on opcode");
    NO_X_Y:      assert final (!$isunknown(y))      else $error("[SVA] X/Z on y");
    NO_X_FLAGS:  assert final (!$isunknown(flags))  else $error("[SVA] X/Z on flags");
  end

endmodule

bind alu alu_sva u_alu_sva (
  .a      (a),
  .b      (b),
  .y      (y),
  .opcode (opcode),
  .flags  (flags)
);