class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  virtual adder_if vif;
  uvm_analysis_port#(item) mon_ap;
  
  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("MON","Virtual iterface not found");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.a or vif.b or vif.cin);
      #0;
      m_item.a = vif.a;
      m_item.b = vif.b;
      m_item.cin = vif.cin;
      m_item.sum = vif.sum;
      m_item.cout = vif.cout;
      mon_ap.write(m_item);
    end
  endtask
endclass
