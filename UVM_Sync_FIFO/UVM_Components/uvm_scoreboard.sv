class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  logic [7:0] exp_fifo[$];
  logic [7:0] exp_rd_data;
  logic exp_full;
  logic exp_empty;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
    
  endfunction
  
  function void write(item s_item);
    bit write_accept;
    bit read_accept;
    logic [7:0] exp_fifo_pop;
    
    if (!s_item.rst_n) begin
      exp_fifo.delete();
      exp_rd_data = '0;
      exp_empty   = 1'b1;
      exp_full    = 1'b0;
      return;
    end
    
    exp_empty = (exp_fifo.size() == 0);
    exp_full  = (exp_fifo.size() == 8);
    
    write_accept = s_item.w_en && !exp_full;
    read_accept  = s_item.r_en && !exp_empty;
    
    if (read_accept) begin
      exp_fifo_pop = exp_fifo.pop_front();

      if (s_item.rd_data !== exp_fifo_pop) begin
        `uvm_error("SB", $sformatf("RD_DATA mismatch | exp=0x%0h act=0x%0h", exp_fifo_pop, s_item.rd_data))
      end
      else begin
        `uvm_info("SB", $sformatf("READ OK | data=0x%0h", s_item.rd_data), UVM_LOW)
      end
    end
    
    if (write_accept) begin
      exp_fifo.push_back(s_item.wr_data);
      `uvm_info("SB", $sformatf("WRITE OK | data=0x%0h", s_item.wr_data), UVM_LOW)
    end
    
    if (s_item.w_en && exp_full) begin
      `uvm_error("SB", "WRITE blocked by FULL")
    end

    if (s_item.r_en && exp_empty) begin
      `uvm_error("SB", "READ blocked by EMPTY")
    end
  endfunction
  
endclass
