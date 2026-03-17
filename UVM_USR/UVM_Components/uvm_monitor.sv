class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual usr_if vif;
  uvm_analysis_port #(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual usr_if)::get(this, "", "usr_vif", vif))
      `uvm_fatal("MON", "Virtual Interface not found!");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.cb);
      m_item.clr = vif.clr;
      m_item.control = vif.control;
      m_item.parallel_in = vif.parallel_in;
      m_item.serial_in_right = vif.serial_in_right;
      m_item.serial_in_left = vif.serial_in_left;
      m_item.parallel_out = vif.parallel_out;
      m_item.serial_out_right = vif.serial_out_right;
      m_item.serial_out_left = vif.serial_out_left;
      mon_ap.write(m_item);
    end
  endtask
endclass
