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
    q_item.rst_n = 1'b0;
    finish_item(q_item);
    //deassert clr
    q_item = item::type_id::create("q_item");
    start_item(q_item);
    q_item.rst_n = 1'b1;
    finish_item(q_item);
    //start operation
    repeat(num) begin
      item q_item = item::type_id::create("q_item");
      start_item(q_item);
      q_item.randomize() with {rst_n == 1'b1;};
      apply_mode(q_item);
      finish_item(q_item);
    end
  endtask
endclass

class write_fifo extends item_seq;
  `uvm_object_utils(write_fifo)
  
  function new(string name = "write_fifo");
    super.new(name);
  endfunction
  
  virtual function void apply_mode(item q_item);
    q_item.w_en = 1'b1;
    q_item.r_en = 1'b0;
  endfunction
endclass

class read_fifo extends item_seq;
  `uvm_object_utils(read_fifo)
  
  function new(string name = "read_fifo");
    super.new(name);
  endfunction
  
  virtual function void apply_mode(item q_item);
    q_item.w_en = 1'b0;
    q_item.r_en = 1'b1;
  endfunction
endclass
