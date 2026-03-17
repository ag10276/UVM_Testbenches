class fun_cov extends uvm_subscriber#(item);
  `uvm_component_utils(fun_cov)
  
  typedef item T;
  T fc_item;
  real cov;
  
  covergroup cg;
    option.per_instance = 1;
    cp_s: coverpoint fc_item.s {bins all[] = {[0:7]};}
  endgroup
  
  function new(string name = "fun_cov", uvm_component parent = null);
    super.new(name, parent);
    fc_item = item::type_id::create("fc_item");
    cg = new();
  endfunction
  
  virtual function void write(T t);
    fc_item.s = t.s;
    cg.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    cov = cg.get_inst_coverage();
    `uvm_info(get_type_name(), $sformatf("Coverage: %0.2f%%", cov), UVM_NONE)
  endfunction
endclass
