class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
  rand bit [3:0] a, b;
  rand bit cin;
  bit [3:0] sum;
  bit cout;
endclass
