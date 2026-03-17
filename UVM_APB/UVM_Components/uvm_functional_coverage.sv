class func_cov extends uvm_subscriber#(item);
  `uvm_component_utils(func_cov)
  
  typedef item T;
  T f_item;
  real cov_signals, cov_transactions, cov_transitions;
  
  logic prev_pwrite;
  logic prev_valid;
  
  covergroup cg_signals;
    option.per_instance = 1;

    cp_resetn  : coverpoint f_item.PRESETn { bins all[] = {[0:1]}; }
    cp_pwrite  : coverpoint f_item.PWRITE  { bins all[] = {[0:1]}; }
    cp_pslverr : coverpoint f_item.PSLVERR { bins all[] = {[0:1]}; }
    cp_pready  : coverpoint f_item.PREADY  { bins all[] = {[0:1]}; }
    cp_addr_range : coverpoint f_item.PADDR[5] {
      bins IN_RANGE  = {1'b0};
      bins OUT_RANGE = {1'b1};
    }
  endgroup
  
  covergroup cg_transactions;
    option.per_instance = 1;

    cp_direction : coverpoint f_item.PWRITE {
      bins READ  = {1'b0};
      bins WRITE = {1'b1};
    }
    cp_range : coverpoint f_item.PADDR[5] {
      bins IN_RANGE  = {1'b0};
      bins OUT_RANGE = {1'b1};
    }
    cp_error : coverpoint f_item.PSLVERR {
      bins NO_ERR = {1'b0};
      bins ERROR  = {1'b1};
    }

    // All four direction x range combinations
    cx_dir_range : cross cp_direction, cp_range;
    cx_dir_error : cross cp_direction, cp_error;
  endgroup
  
  covergroup cg_transitions;
    option.per_instance = 1;

    cp_prev : coverpoint prev_pwrite {
      bins PREV_READ  = {1'b0};
      bins PREV_WRITE = {1'b1};
    }
    cp_curr : coverpoint f_item.PWRITE {
      bins CURR_READ  = {1'b0};
      bins CURR_WRITE = {1'b1};
    }
    cx_b2b : cross cp_prev, cp_curr;
  endgroup
  
  
  
  function new(string name = "func_cov", uvm_component parent = null);
    super.new(name, parent);
    f_item = item::type_id::create("f_item");
    cg_signals     = new();
    cg_transactions = new();
    cg_transitions = new();
    prev_valid  = 1'b0;
    prev_pwrite = 1'b0;
  endfunction
  
  virtual function void write(T t);
    f_item.PRESETn = t.PRESETn;
    f_item.PWRITE = t.PWRITE;
    f_item.PADDR = t.PADDR;
    f_item.PWDATA = t.PWDATA;
    f_item.PRDATA = t.PRDATA;
    f_item.PREADY = t.PREADY;
    f_item.PSLVERR = t.PSLVERR;
    cg_signals.sample();
    if (f_item.PRESETn)
      cg_transactions.sample();
    if (f_item.PRESETn && prev_valid)
      cg_transitions.sample();
    if (!f_item.PRESETn) begin
      prev_valid = 1'b0;
    end else begin
      prev_pwrite = f_item.PWRITE;
      prev_valid  = 1'b1;
    end
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    cov_signals = cg_signals.get_inst_coverage();
    `uvm_info("FC", $sformatf("Coverage Signals: %0.2f%%", cov_signals), UVM_NONE)
    cov_transactions = cg_transactions.get_inst_coverage();
    `uvm_info("FC", $sformatf("Coverage Transactions: %0.2f%%", cov_transactions), UVM_NONE)
    cov_transitions = cg_transitions.get_inst_coverage();
    `uvm_info("FC", $sformatf("Coverage Transistions: %0.2f%%", cov_transitions), UVM_NONE)
  endfunction
endclass
