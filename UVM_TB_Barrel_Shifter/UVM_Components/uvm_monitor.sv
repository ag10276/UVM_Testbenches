class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual bshifter8 vif;
  uvm_analysis_port#(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual bshifter8)::get(this, "", "bshifter8_vif", vif))
      `uvm_fatal("MON", "VIF not found");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.x or vif.s);
      m_item.x = vif.x;
      m_item.s = vif.s;
      m_item.y = vif.y;
      #0;
      mon_ap.write(m_item);
    end
  endtask
endclass
