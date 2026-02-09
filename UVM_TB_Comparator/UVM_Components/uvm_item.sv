class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
  rand bit[1:0] a;
  rand bit [1:0] b;
  bit agreaterb;
  bit aequalb;
  bit alesserb;
endclass