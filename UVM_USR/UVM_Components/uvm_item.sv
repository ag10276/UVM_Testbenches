class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
  rand logic clr;
  rand logic [1:0] control;
  rand logic [7:0] parallel_in;
  rand logic serial_in_right;
  rand logic serial_in_left;
  logic serial_out_right;
  logic serial_out_left;
  logic [7:0] parallel_out;
  
endclass
