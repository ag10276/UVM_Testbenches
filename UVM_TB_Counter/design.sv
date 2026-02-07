module counter(
  input logic clk,
  input logic rst,
  input logic up,
  output logic [3:0] dout
);
  
  always_ff @(posedge clk) begin
    if(rst) begin
      dout <= 0;
    end
    else begin
      if(up == 1'b1) begin
        dout <= dout + 1;
      end else begin
        dout <= dout - 1;
      end
    end
  end 
endmodule

interface counter_if(input logic clk);
  logic rst;
  logic up;
  logic [3:0] dout;
  
  clocking cb_drv @(posedge clk);
    default input #1step output #0; 
    output rst, up;
    input dout;
  endclocking
  
  clocking cb_mon @(posedge clk);
    default input #1step; 
    input rst, up, dout;
  endclocking
  
  modport DRV (clocking cb_drv, input clk);
  modport MON (clocking cb_mon, input clk);       
endinterface