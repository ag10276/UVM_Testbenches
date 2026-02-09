class test extends uvm_test;
	`uvm_component_utils(test)

	function new(string name ="test", uvm_component parent);
		super.new(name, parent);
	endfunction

	env e0;
	virtual decoder_if vif;
	item_seq seq;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      e0 = env::type_id::create("e0", this);
		if(!uvm_config_db#(virtual decoder_if)::get(this, "", "decoder_vif", vif))
		`uvm_fatal("TEST", "Did not get virtual interface");;
      uvm_config_db#(virtual decoder_if)::set(this, "e0.a0.*", "decoder_vif", vif);
		seq = item_seq::type_id::create("seq");
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.randomize();
		seq.start(e0.a0.s0);
		#1;
		phase.drop_objection(this);
	endtask
endclass