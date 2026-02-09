class fun_cov extends uvm_subscriber#(item);
  `uvm_component_utils(fun_cov)
  
  typedef item T;
  T m_item;
  real cov;
  
  covergroup cg;
    option.per_instance = 1;
    
    cp_a: coverpoint m_item.a {bins all[] = {[0:3]};}
    cp_b: coverpoint m_item.b {bins all[] = {[0:3]};}
    cp_axb: cross cp_a, cp_b;
  endgroup
  
  function new(string name = "fun_cov", uvm_component parent);
    super.new(name, parent);
    m_item = item::type_id::create("m_item", this);
    cg = new();
  endfunction
  
  virtual function void write (T t);
    m_item.a = t.a;
    m_item.b = t.b;
    cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    cov = cg.get_inst_coverage();
    `uvm_info(get_type_name(), $sformatf("Coverage: %0.2f%%", cov), UVM_NONE);
  endfunction
endclass