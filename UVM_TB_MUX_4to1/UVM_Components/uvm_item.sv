import uvm_pkg::*;
`include "uvm_macros.svh"

class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  randc logic [3:0] in0;
  randc logic [3:0] in1;
  randc logic [3:0] in2;
  randc logic [3:0] in3;
  randc logic [1:0] sel;
  logic [3:0] out;
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
  constraint c_in0 {in0 inside {[0:15]};}
  constraint c_in1 {in1 inside {[0:15]};}
  constraint c_in2 {in2 inside {[0:15]};}
  constraint c_in3 {in3 inside {[0:15]};}
  constraint c_sel {sel inside {[0:3]};}
  
endclass

