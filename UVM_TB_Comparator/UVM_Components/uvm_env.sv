class env extends uvm_env;
  `uvm_component_utils(env)
 
  agent a0;
  scoreboard sb0;
  fun_cov fc0;
  
  function new(string name ="env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = agent::type_id::create("a0", this);
    sb0 = scoreboard::type_id::create("sb0", this);
    fc0 = fun_cov::type_id::create("fc0", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.mon_ap.connect(sb0.sb_imp);
    a0.m0.mon_ap.connect(fc0.analysis_export);
  endfunction
endclass