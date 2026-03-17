class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction

  rand logic reset;
  logic [1:0] light_NS; 
  logic [1:0] light_EW;
  
endclass
