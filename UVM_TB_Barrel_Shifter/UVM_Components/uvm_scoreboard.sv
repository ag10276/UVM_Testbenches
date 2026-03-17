class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp#(item, scoreboard) sb_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  logic [7:0] exp_y, a, b;
  
  function void write(item s_item);
    a = s_item.s[0] ? {1'b0, s_item.x[7:1]} : s_item.x;
	b = s_item.s[1] ? {2'b00, a[7:2]} : a;
	exp_y = s_item.s[2] ? {4'b0000, b[7:4]} : b;
    
    if(exp_y == s_item.y) begin
      `uvm_info("SB", "Result as expected", UVM_NONE);
    end else begin
      `uvm_error("SB", "Debug required");
    end
  endfunction
endclass
