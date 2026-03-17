class fun_cov extends uvm_subscriber#(item);
  `uvm_component_utils(fun_cov)
  
  typedef item T;
  T fc_item;
  real cov;
  
  covergroup cg;
    option.per_instance = 1;
    
    cp_a: coverpoint fc_item.a {bins all[] = {[0:15]};}
    cp_b: coverpoint fc_item.b {bins all[] = {[0:15]};}
    cp_cin: coverpoint fc_item.cin {bins all[] = {[0:1]};}
    
    cp_a_b_cin: cross cp_a, cp_b, cp_cin;
  endgroup
  
  function new(string name = "fun_cov", uvm_component parent);
    super.new(name, parent);
    fc_item = item::type_id::create("fc_item");
    cg = new();
  endfunction
  
  virtual function void write (T t);
    fc_item.a = t.a;
    fc_item.b = t.b;
    fc_item.cin = t.cin;
    cg.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    cov = cg.get_inst_coverage();
    `uvm_info(get_type_name(), $sformatf("Functional Coverage: %0.2f%%", cov), UVM_NONE)
  endfunction
endclass
