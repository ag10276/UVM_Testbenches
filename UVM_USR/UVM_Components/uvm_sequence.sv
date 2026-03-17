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
      q_item.clr = 1'b1;
      q_item.control = 2'b00;
      q_item.parallel_in = '0;
      q_item.serial_in_left = 1'b0;
      q_item.serial_in_right= 1'b0;
    finish_item(q_item);
    //deassert clr
    q_item = item::type_id::create("q_item");
    start_item(q_item);
    q_item.clr = 1'b0;
  	q_item.control = 2'b00; // hold
  	q_item.parallel_in = '0;
  	q_item.serial_in_left = 1'b0;
  	q_item.serial_in_right= 1'b0;
    finish_item(q_item);
    //start operation
    repeat(num) begin
      item q_item = item::type_id::create("q_item");
      start_item(q_item);
      q_item.randomize() with {clr == 1'b0;};
      apply_mode(q_item);
      finish_item(q_item);
    end
  endtask
endclass

class right_shift_seq extends item_seq;
  `uvm_object_utils(right_shift_seq)
  
  function new(string name = "right_shift_seq");
    super.new(name);
  endfunction
  
  virtual function void apply_mode(item q_item);
    q_item.control = 2'b01;
  endfunction
endclass

class left_shift_seq extends item_seq;
  `uvm_object_utils(left_shift_seq)
  
  function new(string name = "left_shift_seq");
    super.new(name);
  endfunction
  
  virtual function void apply_mode(item q_item);
    q_item.control = 2'b10;
  endfunction
endclass

class parallel_seq extends item_seq;
  `uvm_object_utils(parallel_seq)
  
  function new(string name = "parallel_seq");
    super.new(name);
  endfunction
  
  virtual function void apply_mode(item q_item);
    q_item.control = 2'b11;
  endfunction
endclass
