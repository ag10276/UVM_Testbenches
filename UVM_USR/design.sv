module universal_shift_register(
  input logic clk,
  input logic clr,
  input logic [1:0] control,
  input logic [7:0] parallel_in,
  input logic serial_in_right,
  input logic serial_in_left,
  output logic serial_out_right,
  output logic serial_out_left,
  output logic [7:0] parallel_out
);
  
  
  always@(posedge clk) begin
    if(clr) begin
      parallel_out <= 0;
    end else begin
      case(control)
        2'b00: parallel_out <= parallel_out; //hold
        2'b01: parallel_out <= {serial_in_left, parallel_out[7:1]}; //right shift
        2'b10: parallel_out <= {parallel_out[6:0], serial_in_right}; //left shift
        2'b11: parallel_out <= parallel_in; //parallel
        default: begin
        end
      endcase
    end
  end
  
  assign serial_out_right = parallel_out[0];
  assign serial_out_left = parallel_out[7];
  
endmodule

interface usr_if(input logic clk);
  logic clr;
  logic [1:0] control;
  logic [7:0] parallel_in;
  logic serial_in_right;
  logic serial_in_left;
  logic serial_out_right;
  logic serial_out_left;
  logic [7:0] parallel_out;
  
  clocking cb @(posedge clk);
    default input #1step output #0; 
    output clr, control, parallel_in, serial_in_right, serial_in_left;
    input serial_out_right, serial_out_left, parallel_out;
  endclocking 
endinterface