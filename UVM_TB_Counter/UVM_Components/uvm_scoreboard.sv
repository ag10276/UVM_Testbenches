class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  bit [3:0] past_dout = 0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  /*function void write(item s_item);
    if(s_item.rst) begin
      if(s_item.dout == 0) begin
        `uvm_info("SB", "Dout is 0 as rst is high", UVM_LOW)
        past_dout = 0;
      end else begin
        `uvm_error("SB", "Dout is not 0, why?")
	`uvm_info("SB",$sformatf("rst:%0d, up:%0d",s_item.rst, s_item.up),UVM_LOW)
      end
    end
    else begin
      if (s_item.up == 1'b1) begin
        if(s_item.dout == past_dout + 1) begin
          `uvm_info("SB", $sformatf("Dout is one higher. Past: %0d, Current: %0d", past_dout, s_item.dout), UVM_LOW)
          if(s_item.dout == 15) past_dout = 0;
	  else past_dout = s_item.dout;
        end else begin
          `uvm_error("SB", $sformatf("UP Dout is incorrect. Past: %0d, Current: %0d", past_dout, s_item.dout))
	`uvm_info("SB Debug",$sformatf("rst:%0d, up:%0d",s_item.rst, s_item.up),UVM_LOW)
        end
      end else begin
        if(s_item.dout == past_dout - 1) begin
          `uvm_info("SB", $sformatf("Dout is one lower. Past: %0d, Current: %0d", past_dout, s_item.dout), UVM_LOW)
          past_dout = s_item.dout;
        end else begin
          `uvm_error("SB", $sformatf("DOWN Dout is incorrect. Past: %0d, Current: %0d", past_dout, s_item.dout))
	`uvm_info("SB Debug",$sformatf("rst:%0d, up:%0d",s_item.rst, s_item.up),UVM_LOW)	
        end
      end
    end
  endfunction */

  function void write(item s_item);
    logic [3:0] exp;

    if (s_item.rst) begin
      if (s_item.dout !== 4'd0)
        `uvm_error("SB", $sformatf("RST high but dout=%0d (exp 0)", s_item.dout))
      past_dout = 4'd0;
      return;
    end

    if (s_item.up)
      exp = past_dout + 4'd1; 
    else
      exp = past_dout - 4'd1;

    if (s_item.dout !== exp) begin
      `uvm_error("SB", $sformatf(
        "Mismatch: up=%0b past=%0d exp=%0d got=%0d",
        s_item.up, past_dout, exp, s_item.dout
      ))
    end else begin
      `uvm_info("SB", $sformatf(
        "OK: up=%0b past=%0d got=%0d",
        s_item.up, past_dout, s_item.dout
      ), UVM_LOW)
    end
    past_dout = s_item.dout;
  endfunction
endclass
