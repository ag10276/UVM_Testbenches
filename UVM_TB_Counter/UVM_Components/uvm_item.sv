class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  rand bit rst;
  rand bit up;
  bit [3:0] dout;
  
  constraint c_rst {rst dist {1:=5, 0:=95};}
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
endclass
