class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  logic [31:0] exp_mem [31:0];
  int pass_cnt, fail_cnt;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  function void write(item s_item);
    if (!s_item.PRESETn) begin
      foreach (exp_mem[i]) exp_mem[i] = '0;
      chk("RESET: PRDATA=0", s_item.PRDATA  === 32'h0);
      chk("RESET: PREADY=0", s_item.PREADY  === 1'b0);
      chk("RESET: PSLVERR=0", s_item.PSLVERR === 1'b0);
      return;
    end
    
    if (s_item.PADDR[5]) begin
      chk($sformatf("OOR %s PADDR=0x%02h: PSLVERR=1",
            s_item.PWRITE ? "WRITE" : "READ", s_item.PADDR),
          s_item.PSLVERR === 1'b1);
      if (!s_item.PWRITE)
        chk("OOR READ: PRDATA=0", s_item.PRDATA === 32'h0);
      return;
    end
    
    chk($sformatf("VALID %s PADDR=0x%02h: PSLVERR=0",
          s_item.PWRITE ? "WRITE" : "READ", s_item.PADDR),
        s_item.PSLVERR === 1'b0);

    if (s_item.PWRITE) begin
      exp_mem[s_item.PADDR[4:0]] = s_item.PWDATA;
      `uvm_info("SB", $sformatf("WRITE OK | addr=0x%02h data=0x%08h",
        s_item.PADDR, s_item.PWDATA), UVM_LOW)
    end else begin
      chk($sformatf("READ ADDR=0x%02h data match", s_item.PADDR),
          s_item.PRDATA === exp_mem[s_item.PADDR[4:0]]);
    end
  endfunction

  function void chk(string msg, logic pass);
    if (pass) begin
      `uvm_info("SB", $sformatf("PASS: %s", msg), UVM_MEDIUM)
      pass_cnt++;
    end else begin
      `uvm_error("SB", $sformatf("FAIL: %s", msg))
      fail_cnt++;
    end
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    `uvm_info("SB", $sformatf("Scoreboard: %0d PASS  %0d FAIL",
      pass_cnt, fail_cnt), UVM_NONE)
  endfunction
  
endclass
