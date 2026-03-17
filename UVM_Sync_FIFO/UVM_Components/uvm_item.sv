class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction

  rand bit rst_n;
  rand bit w_en;
  rand bit r_en;
  rand bit [7:0] wr_data;
  logic [7:0] rd_data;
  logic full;
  logic empty;
  
  constraint c_ctrl {
  {w_en, r_en} dist {
    2'b00 := 1,
    2'b01 := 3,
    2'b10 := 3,
    2'b11 := 1
  };
}
endclass
