import uvm_pkg::*;
`include "uvm_macros.svh"

class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new(string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num {num inside {[100:300]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize());
      finish_item(m_item);
    end
  endtask
endclass

