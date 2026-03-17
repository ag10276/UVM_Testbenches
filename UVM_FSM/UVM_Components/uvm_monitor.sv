class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual fsm_if vif;
  uvm_analysis_port #(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fsm_if)::get(this, "", "fsm_vif", vif))
      `uvm_fatal("MON", "Virtual Interface not found!");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.cb);
      m_item.reset = vif.reset;
      m_item.light_NS = vif.light_NS;
      m_item.light_EW = vif.light_EW;
      mon_ap.write(m_item);
    end
  endtask
endclass
