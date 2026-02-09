class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual decoder_if vif;
	uvm_analysis_port #(item) mon_ap;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual decoder_if)::get(this, "", "decoder_vif", vif)) 
		`uvm_fatal("MON", "Did not get virtual interface");
		mon_ap = new("mon_ap", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			item m_item = item::type_id::create("m_item");
			@(vif.a);
			#0;
			m_item.a = vif.a;
			m_item.d = vif.d;
			mon_ap.write(m_item);
		end
	endtask
endclass