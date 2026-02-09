class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  function void write(item s_item);
    `uvm_info("SB", $sformatf("a: %0d, b: %0d", s_item.a, s_item.b), UVM_NONE)
    if(s_item.a > s_item.b) begin
      if(s_item.agreaterb == 1'b1 && s_item.aequalb == 1'b0 && s_item.alesserb == 1'b0) begin
        `uvm_info("SB", "Greater SUCCESS: A greater than B", UVM_NONE);
      end
      else begin
        `uvm_error("SB", $sformatf("Greater FAIL: Expected g = %0d, e = %0d, l = %0d; Got g = %0d, e = %0d, l = %0d", 1, 0, 0, s_item.agreaterb, s_item.aequalb, s_item.alesserb)); 
      end
    end else if (s_item.a < s_item.b) begin
      if(s_item.agreaterb == 1'b0 && s_item.aequalb == 1'b0 && s_item.alesserb == 1'b1) begin
        `uvm_info("SB", "Lesser SUCCESS: A lesser than B", UVM_NONE);
      end
      else begin
        `uvm_error("SB", $sformatf("Lesser FAIL: Expected g = %0d, e = %0d, l = %0d; Got g = %0d, e = %0d, l = %0d", 0, 0, 1, s_item.agreaterb, s_item.aequalb, s_item.alesserb)); 
      end
    end else begin
      if(s_item.agreaterb == 1'b0 && s_item.aequalb == 1'b1 && s_item.alesserb == 1'b0) begin
        `uvm_info("SB", "Equal SUCCESS: A equal to B", UVM_NONE);
      end
      else begin
        `uvm_error("SB", $sformatf("Equal FAIL: Expected g = %0d, e = %0d, l = %0d; Got g = %0d, e = %0d, l = %0d", 0, 1, 0, s_item.agreaterb, s_item.aequalb, s_item.alesserb)); 
      end
    end
  endfunction
endclass