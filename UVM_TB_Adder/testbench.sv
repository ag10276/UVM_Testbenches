import uvm_pkg::*;
`include "uvm_macros.svh"

class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
  rand bit [3:0] a, b;
  rand bit cin;
  bit [3:0] sum;
  bit cout;
endclass

class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new(string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num {num inside {[500:1000]};} 
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("item");
      start_item(m_item);
      m_item.randomize();
      finish_item(m_item);
    end
  endtask
endclass

class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual adder_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("DRV", "Could not get vif");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item d_item;
      seq_item_port.get_next_item(d_item);
      vif.a = d_item.a;
      vif.b = d_item.b;
      vif.cin = d_item.cin;
      #0;
      seq_item_port.item_done();
      #1;
    end
  endtask
endclass

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

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp#(item, scoreboard) sb_imp;
  
  logic [3:0] exp_sum;
  logic exp_cout;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  function void write(item s_item);
    {exp_cout, exp_sum} = s_item.a + s_item.b + s_item.cin;
    
    if(s_item.sum == exp_sum && s_item.cout == exp_cout) begin
      `uvm_info("SB", "Sum and Cout are as expected", UVM_NONE);
    end else begin
      `uvm_error("SB", $sformatf("a: %0d, b:%0d, cin:%0d, op_sum:%0d, op_cout:%0d, exp_sum:%0d, exp+cout:%0d",s_item.a, s_item.b, s_item.cin, s_item.sum, s_item.cout, exp_sum, exp_cout));
    end
  endfunction
endclass

class fun_cov extends uvm_subscriber#(item);
  `uvm_component_utils(fun_cov)
  
  typedef item T;
  T fc_item;
  real cov;
  
  covergroup cg;
    option.per_instance = 1;
    
    cp_a: coverpoint fc_item.a {bins all[] = {[0:15]};}
    cp_b: coverpoint fc_item.b {bins all[] = {[0:15]};}
    cp_cin: coverpoint fc_item.cin {bins all[] = {[0:1]};}
    
    cp_a_b_cin: cross cp_a, cp_b, cp_cin;
  endgroup
  
  function new(string name = "fun_cov", uvm_component parent);
    super.new(name, parent);
    fc_item = item::type_id::create("fc_item");
    cg = new();
  endfunction
  
  virtual function void write (T t);
    fc_item.a = t.a;
    fc_item.b = t.b;
    fc_item.cin = t.cin;
    cg.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    cov = cg.get_inst_coverage();
    `uvm_info(get_type_name(), $sformatf("Functional Coverage: %0.2f%%", cov), UVM_NONE)
  endfunction
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  monitor m0;
  driver d0;
  uvm_sequencer#(item) s0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m0 = monitor::type_id::create("m0", this);
    d0 = driver::type_id::create("d0", this);
    s0 = uvm_sequencer#(item)::type_id::create("s0", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d0.seq_item_port.connect(s0.seq_item_export);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  
  function new(string name="env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  agent a0;
  fun_cov fc0;
  scoreboard sb0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = agent::type_id::create("a0", this);
    fc0 = fun_cov::type_id::create("fc0", this);
    sb0 = scoreboard::type_id::create("sb0", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    a0.m0.mon_ap.connect(sb0.sb_imp);
    a0.m0.mon_ap.connect(fc0.analysis_export);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test);
  
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual adder_if vif;
  env e0;
  item_seq seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("env", this);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif))
      `uvm_fatal("ENV","Virtual iterface not found");
    uvm_config_db#(virtual adder_if)::set(this, "e0.a0.*", "adder_vif", vif);
    seq = item_seq::type_id::create("seq");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
endclass

module tb_top;
  adder_if _if();
  adder dut(
    .a(_if.a),
    .b(_if.b),
    .cin(_if.cin),
    .sum(_if.sum),
    .cout(_if.cout)
  );
  
  initial begin
    uvm_config_db#(virtual adder_if)::set(null, "*", "adder_vif", _if);
    run_test("test");
  end
endmodule