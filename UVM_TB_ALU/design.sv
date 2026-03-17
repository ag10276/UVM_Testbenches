module alu(
  input logic [7:0] a, b,
  output logic [7:0] y,
  input logic [2:0] opcode,
  output logic [3:0] flags
);
  
  logic [8:0] y_complete;
  
  /*
  Opcode: Operation
  000: add a and b
  001: subtract b from a
  010: bitwise AND
  011: bitwise OR
  100: bitwise XOR
  101: bitwise NOT
  110: logical shift left
  111: logical shift right
  
  Flags:
  0: Sign Flag
  1: Carry Flag
  2: Zero Flag
  3: Overflow Flag
  */
  
  always_comb begin
    y_complete = 9'b000000000;
    y = 8'b00000000;
    flags = 4'b0000;
    case(opcode)
      3'b000: begin
        y_complete = {1'b0, a}+{1'b0, b};
        y = y_complete[7:0];
        flags[1] = y_complete[8];
        flags[3] = (~a[7] & ~b[7] & y[7]) | (a[7] & b[7] & ~y[7]); 
      end
      3'b001: begin
        y_complete = {1'b0, a}+{1'b0, ~b} +8'b1;
        y = y_complete[7:0];
        flags[1] = y_complete[8];
        flags[3] = (a[7] & ~b[7] & ~y[7]) | (~a[7] & b[7] & y[7]); 
      end
      3'b010: begin
        y = a & b;
      end
      3'b011: begin
        y = a | b;
      end
      3'b100: begin
        y = a ^ b;
      end
      3'b101: begin
        y = ~a;
      end
      3'b110: begin
        flags[1] = a[7];
        y = a << 1;
      end
      3'b111: begin
        flags[1] = a[0];
        y = a >> 1;
      end
    endcase
    flags[0] = y[7];
    flags[2] = (y == 8'b00000000);
  end
endmodule

interface alu_if;
  logic [7:0] a;
  logic [7:0] b;
  logic [7:0] y;
  logic [2:0] opcode;
  logic [3:0] flags;
endinterface