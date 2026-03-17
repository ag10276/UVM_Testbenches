class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
  rand bit[7:0] x;
  rand bit[2:0] s;
  bit [7:0] y;
endclass
