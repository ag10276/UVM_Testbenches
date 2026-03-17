class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  rand bit [7:0] a,b;
  rand bit [2:0] opcode;
  bit [7:0] y;
  bit [3:0] flags;
  
  function new(string name = "item");
    super.new(name);
  endfunction
endclass
