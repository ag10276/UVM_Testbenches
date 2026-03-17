class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new(string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num {num inside {[30:50]};}
  
  virtual function void apply_mode(item q_item);
  endfunction
  
  virtual task body();
    //item q_item;
    //assert clr
    item q_item = item::type_id::create("q_item");
    start_item(q_item);
      q_item.reset = 1'b1;
    finish_item(q_item);
    //deassert clr
    q_item = item::type_id::create("q_item");
    start_item(q_item);
    q_item.reset = 1'b0;
    finish_item(q_item);
    //start operation
    repeat(num) begin
      item q_item = item::type_id::create("q_item");
      start_item(q_item);
      q_item.randomize() with {reset == 1'b0;};
      apply_mode(q_item);
      finish_item(q_item);
    end
  endtask
endclass
