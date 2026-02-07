import uvm_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp#(item, scoreboard) scb_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_imp = new("scb_imp", this);
  endfunction
  
  function void write(item s_item);
    case(s_item.sel)
      2'b00: begin
        if(s_item.out == s_item.in0) begin
          `uvm_info("SCB", "S00: Expected Output", UVM_LOW);
          end else begin
          `uvm_error("SCB", "S00: Not the Expected Output");
          end
      end
        
      2'b01: begin
        if(s_item.out == s_item.in1) begin
          `uvm_info("SCB", "S01: Expected Output", UVM_LOW);
          end else begin
          `uvm_error("SCB", "S01: Not the Expected Output");
          end
      end
      
      2'b10: begin
        if(s_item.out == s_item.in2) begin
          `uvm_info("SCB", "S10: Expected Output", UVM_LOW);
          end else begin
          `uvm_error("SCB", "S10: Not the Expected Output");
          end
      end
      
      2'b11: begin
        if(s_item.out == s_item.in3) begin
          `uvm_info("SCB", "S11: Expected Output", UVM_LOW);
          end else begin
          `uvm_error("SCB", "S11: Not the Expected Output");
          end
      end
      
    endcase  
  endfunction 
endclass

