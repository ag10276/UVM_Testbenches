class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new(string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int unsigned num;
  constraint c_num {num inside {[30:50]};}
  
  virtual function void apply_mode(item q_item);
  endfunction
  
  virtual task body();
    //item q_item;
    //assert resetn
    item q_item = item::type_id::create("q_item");
    start_item(q_item);
    q_item.PRESETn = 1'b0;
    q_item.PSEL = 1'b0;
    q_item.PENABLE = 1'b0;
    finish_item(q_item);
    //deassert resetn
    q_item = item::type_id::create("q_item");
    start_item(q_item);
    q_item.PRESETn = 1'b1;
    q_item.PSEL = 1'b0;
    q_item.PENABLE = 1'b0;
    finish_item(q_item);
    //start operation
    repeat(num) begin
      item q_item = item::type_id::create("q_item");
      start_item(q_item);
      q_item.randomize() with {PRESETn == 1'b1;};
      apply_mode(q_item);
      finish_item(q_item);
    end
  endtask
endclass

class write_seq extends item_seq;
  `uvm_object_utils(write_seq)

  function new(string name = "write_seq");
    super.new(name);
  endfunction

  virtual function void apply_mode(item q_item);
    q_item.PWRITE = 1'b1;
    q_item.PADDR = q_item.PADDR & 6'h1F;   
  endfunction
endclass

class read_seq extends item_seq;
  `uvm_object_utils(read_seq)

  function new(string name = "read_seq");
    super.new(name);
  endfunction

  virtual function void apply_mode(item q_item);
    q_item.PWRITE = 1'b0;
    q_item.PADDR = q_item.PADDR & 6'h1F;  
  endfunction
endclass

class oor_seq extends item_seq;
  `uvm_object_utils(oor_seq)

  function new(string name = "oor_seq");
    super.new(name);
  endfunction

  virtual function void apply_mode(item q_item);
    q_item.PADDR[5] = 1'b1; 
  endfunction
endclass
