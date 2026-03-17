class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp#(item, scoreboard) sb_imp;
  
  logic [3:0] exp_sum;
  logic exp_cout;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  function void write(item s_item);
    {exp_cout, exp_sum} = s_item.a + s_item.b + s_item.cin;
    
    if(s_item.sum == exp_sum && s_item.cout == exp_cout) begin
      `uvm_info("SB", "Sum and Cout are as expected", UVM_NONE);
    end else begin
      `uvm_error("SB", $sformatf("a: %0d, b:%0d, cin:%0d, op_sum:%0d, op_cout:%0d, exp_sum:%0d, exp+cout:%0d",s_item.a, s_item.b, s_item.cin, s_item.sum, s_item.cout, exp_sum, exp_cout));
    end
  endfunction
endclass
