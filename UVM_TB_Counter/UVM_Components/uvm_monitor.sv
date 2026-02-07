class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_port#(item) mon_ap;
  virtual counter_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif)) `uvm_fatal("MON", "Virtual Interface not found");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.cb_mon);
      m_item.rst = vif.rst;
      m_item.up = vif.up;
      m_item.dout = vif.dout;
      mon_ap.write(m_item);
    end
  endtask
endclass
