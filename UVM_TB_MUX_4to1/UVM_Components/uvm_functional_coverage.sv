import uvm_pkg::*;
`include "uvm_macros.svh"

class fun_cov extends uvm_subscriber#(item);
  `uvm_component_utils(fun_cov)
  
  typedef item T;
  T    m_item;
  real cov;
  
  covergroup cg;
    option.per_instance = 1;
    cp_sel : coverpoint m_item.sel {
      bins s00 = {2'b00};
      bins s01 = {2'b01};
      bins s10 = {2'b10};
      bins s11 = {2'b11};
    }
    
    cp_in0: coverpoint m_item.in0 {bins all[] = {[0:15]};}
    cp_in1: coverpoint m_item.in1 {bins all[] = {[0:15]};}
    cp_in2: coverpoint m_item.in2 {bins all[] = {[0:15]};}
    cp_in3: coverpoint m_item.in3 {bins all[] = {[0:15]};}
    
    cx_sel_in0 : cross cp_sel, cp_in0 {bins valid_sel0 = binsof(cp_sel) intersect {2'b00};}
    cx_sel_in1 : cross cp_sel, cp_in1 {bins valid_sel1 = binsof(cp_sel) intersect {2'b01};}
    cx_sel_in2 : cross cp_sel, cp_in2 {bins valid_sel2 = binsof(cp_sel) intersect {2'b10};}
    cx_sel_in3 : cross cp_sel, cp_in3 {bins valid_sel3 = binsof(cp_sel) intersect {2'b11};}
  endgroup
    
  function new(string name = "fun_cov", uvm_component parent = null);
    super.new(name, parent);
    m_item = item::type_id::create("m_item", this);
    cg = new();
  endfunction
  
  virtual function void write(T t);
    m_item.in0 = t.in0;
  m_item.in1 = t.in1;
  m_item.in2 = t.in2;
  m_item.in3 = t.in3;
  m_item.sel = t.sel;
    cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    cov = cg.get_inst_coverage ();
    `uvm_info(get_type_name(), $sformatf("Coverage is: %0.2f%%", cov), UVM_MEDIUM)
  endfunction
  
endclass

