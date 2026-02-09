class fun_cov extends uvm_subscriber#(item);
  `uvm_component_utils(fun_cov)
  
  typedef item T;
  T m_item;
  real cov;
  
  covergroup cg;
    option.per_instance = 1;
    cp_a: coverpoint m_item.a {bins all[] = {[0:7]};}
  endgroup
  
  function new(string name = "fun_cov", uvm_component parent);
    super.new(name, parent);
    m_item = item::type_id::create("m_item");
    cg = new();
  endfunction
  
  virtual function void write(T t);
    m_item.a = t.a;
    cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    cov = cg.get_inst_coverage();
    `uvm_info(get_type_name(), $sformatf("Coverage is: %0.2f%%", cov), UVM_LOW)
  endfunction
endclass