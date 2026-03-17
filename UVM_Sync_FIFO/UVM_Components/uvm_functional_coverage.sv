class func_cov extends uvm_subscriber#(item);
  `uvm_component_utils(func_cov)
  
  typedef item T;
  T f_item;
  real cov;
  
  covergroup cg;
	option.per_instance = 1;
    cp_rst_n : coverpoint f_item.rst_n {bins all[] = {[0:1]};}                                            
    cp_w_en : coverpoint f_item.w_en {bins all[] = {[0:1]};}
    cp_r_en : coverpoint f_item.r_en {bins all[] = {[0:1]};}
    cp_full : coverpoint f_item.full {bins all[] = {[0:1]};}
    cp_empty : coverpoint f_item.empty {bins all[] = {[0:1]};}                                                
  endgroup
  
  function new(string name = "func_cov", uvm_component parent = null);
    super.new(name, parent);
    f_item = item::type_id::create("f_item");
    cg = new();
  endfunction
  
  virtual function void write(T t);
    f_item.rst_n = t.rst_n;
    f_item.w_en = t.w_en;
    f_item.r_en = t.r_en;
    f_item.full = t.full;
    f_item.empty = t.empty;
    cg.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    cov = cg.get_inst_coverage();
    `uvm_info("FC", $sformatf("Coverage: %0.2f%%", cov), UVM_NONE)
  endfunction
endclass
