class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new(string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num {num inside {[40:50]};}
  
  virtual task body();
    repeat(num) begin
      item q_item = item::type_id::create("q_item");
      start_item(q_item);
      q_item.randomize();
      finish_item(q_item);
    end
  endtask
endclass
