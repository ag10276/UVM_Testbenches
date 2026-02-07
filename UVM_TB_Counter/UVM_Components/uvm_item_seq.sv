class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new (string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num{num inside {[50:70]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize());
      finish_item(m_item);
    end
  endtask 
endclass

class up_item_seq extends uvm_sequence#(item);
  `uvm_object_utils(up_item_seq)
  
  function new (string name = "up_item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num{num inside {[30:40]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize() with {up == 1; rst == 0;});
      finish_item(m_item);
    end
  endtask 
endclass

class down_item_seq extends uvm_sequence#(item);
  `uvm_object_utils(down_item_seq)
  
  function new (string name = "down_item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num{num inside {[30:40]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize() with {up == 0;});
      finish_item(m_item);
    end
  endtask 
endclass

