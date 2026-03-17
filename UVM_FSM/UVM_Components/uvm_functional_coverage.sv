class func_cov extends uvm_subscriber#(item);
  `uvm_component_utils(func_cov)
  
  typedef item T;
  T f_item;
  real cov;
  
  covergroup cg;
	option.per_instance = 1;
    cp_reset : coverpoint f_item.reset {bins all[] = {[0:1]};}                                            
    cp_light_NS : coverpoint f_item.light_NS {
      bins red    = {2'b00};
      bins yellow = {2'b01};
      bins green  = {2'b10};
    }
    cp_light_EW : coverpoint f_item.light_EW {
      bins red    = {2'b00};
      bins yellow = {2'b01};
      bins green  = {2'b10};
    }                                                     
  endgroup
  
  function new(string name = "func_cov", uvm_component parent = null);
    super.new(name, parent);
    f_item = item::type_id::create("f_item");
    cg = new();
  endfunction
  
  virtual function void write(T t);
    f_item.reset = t.reset;
    f_item.light_NS = t.light_NS;
    f_item.light_EW = t.light_EW;
    cg.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    cov = cg.get_inst_coverage();
    `uvm_info("FC", $sformatf("Coverage: %0.2f%%", cov), UVM_NONE)
  endfunction
endclass

