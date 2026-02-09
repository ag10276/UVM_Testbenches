class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual comp_if vif;
  uvm_analysis_port #(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual comp_if)::get(this, "", "comp_vif", vif))
      `uvm_fatal("DRV", "Could not get virtual interface");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.a or vif.b);
      #0;
      m_item.a = vif.a;
      m_item.b = vif.b;
      m_item.agreaterb = vif.agreaterb;
      m_item.aequalb = vif.aequalb;
      m_item.alesserb = vif.alesserb;
      mon_ap.write(m_item);
    end
  endtask
endclass