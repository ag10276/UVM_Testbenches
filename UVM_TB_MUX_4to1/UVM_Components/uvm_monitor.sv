import uvm_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name ="monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual mux_if vif;
  uvm_analysis_port #(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mux_vif", vif))
      `uvm_fatal("MON", "Virtual Interface not found");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.in0 or vif.in1 or vif.in2 or vif.in3 or vif.sel);
      #0;
      m_item.in0 = vif.in0;
      m_item.in1 = vif.in1;
      m_item.in2 = vif.in2;
      m_item.in3 = vif.in3;
      m_item.sel = vif.sel;
      m_item.out = vif.out;
      mon_ap.write(m_item);
      //#1;
    end
  endtask
endclass

