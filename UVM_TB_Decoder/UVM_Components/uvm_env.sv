class env extends uvm_env;
	`uvm_component_utils(env)

	function new(string name = "env", uvm_component parent);
		super.new(name, parent);
	endfunction

	agent a0;
	scoreboard sb0;
  	fun_cov fc0;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a0 = agent::type_id::create("a0", this);
		sb0 = scoreboard::type_id::create("sb0", this);
      fc0 = fun_cov::type_id::create("fc0", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a0.m0.mon_ap.connect(sb0.scb_imp);
      	a0.m0.mon_ap.connect(fc0.analysis_export);
	endfunction
endclass