import uvm_pkg::*;
`include "uvm_macros.svh"

class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  rand bit rst;
  rand bit up;
  bit [3:0] dout;
  
  constraint c_rst {rst dist {1:=5, 0:=95};}
  
  function new(string name = "item");
    super.new(name);
  endfunction
  
endclass

class item_seq extends uvm_sequence#(item);
  `uvm_object_utils(item_seq)
  
  function new (string name = "item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num{num inside {[50:70]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize());
      finish_item(m_item);
    end
  endtask 
endclass

class up_item_seq extends uvm_sequence#(item);
  `uvm_object_utils(up_item_seq)
  
  function new (string name = "up_item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num{num inside {[30:40]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize() with {up == 1; rst == 0;});
      finish_item(m_item);
    end
  endtask 
endclass

class down_item_seq extends uvm_sequence#(item);
  `uvm_object_utils(down_item_seq)
  
  function new (string name = "down_item_seq");
    super.new(name);
  endfunction
  
  rand int num;
  constraint c_num{num inside {[30:40]};}
  
  virtual task body();
    repeat(num) begin
      item m_item = item::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize() with {up == 0;});
      finish_item(m_item);
    end
  endtask 
endclass


class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual counter_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif)) `uvm_fatal("DRV", "VIF not found");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item;
      seq_item_port.get_next_item(m_item);
      @(vif.cb_drv);
      vif.rst <= m_item.rst;
      vif.up <= m_item.up;
      seq_item_port.item_done();
    end
  endtask
endclass


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

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  bit [3:0] past_dout = 0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  /*function void write(item s_item);
    if(s_item.rst) begin
      if(s_item.dout == 0) begin
        `uvm_info("SB", "Dout is 0 as rst is high", UVM_LOW)
        past_dout = 0;
      end else begin
        `uvm_error("SB", "Dout is not 0, why?")
	`uvm_info("SB",$sformatf("rst:%0d, up:%0d",s_item.rst, s_item.up),UVM_LOW)
      end
    end
    else begin
      if (s_item.up == 1'b1) begin
        if(s_item.dout == past_dout + 1) begin
          `uvm_info("SB", $sformatf("Dout is one higher. Past: %0d, Current: %0d", past_dout, s_item.dout), UVM_LOW)
          if(s_item.dout == 15) past_dout = 0;
	  else past_dout = s_item.dout;
        end else begin
          `uvm_error("SB", $sformatf("UP Dout is incorrect. Past: %0d, Current: %0d", past_dout, s_item.dout))
	`uvm_info("SB Debug",$sformatf("rst:%0d, up:%0d",s_item.rst, s_item.up),UVM_LOW)
        end
      end else begin
        if(s_item.dout == past_dout - 1) begin
          `uvm_info("SB", $sformatf("Dout is one lower. Past: %0d, Current: %0d", past_dout, s_item.dout), UVM_LOW)
          past_dout = s_item.dout;
        end else begin
          `uvm_error("SB", $sformatf("DOWN Dout is incorrect. Past: %0d, Current: %0d", past_dout, s_item.dout))
	`uvm_info("SB Debug",$sformatf("rst:%0d, up:%0d",s_item.rst, s_item.up),UVM_LOW)	
        end
      end
    end
  endfunction */

  function void write(item s_item);
    logic [3:0] exp;

    if (s_item.rst) begin
      if (s_item.dout !== 4'd0)
        `uvm_error("SB", $sformatf("RST high but dout=%0d (exp 0)", s_item.dout))
      past_dout = 4'd0;
      return;
    end

    if (s_item.up)
      exp = past_dout + 4'd1; 
    else
      exp = past_dout - 4'd1;

    if (s_item.dout !== exp) begin
      `uvm_error("SB", $sformatf(
        "Mismatch: up=%0b past=%0d exp=%0d got=%0d",
        s_item.up, past_dout, exp, s_item.dout
      ))
    end else begin
      `uvm_info("SB", $sformatf(
        "OK: up=%0b past=%0d got=%0d",
        s_item.up, past_dout, s_item.dout
      ), UVM_LOW)
    end
    past_dout = s_item.dout;
  endfunction
endclass

// class functional_coverage extends uvm_subscriber#(item);
// endclass

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
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  agent a0;
  scoreboard sb0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = agent::type_id::create("a0", this);
    sb0 = scoreboard::type_id::create("sb0", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.mon_ap.connect(sb0.sb_imp);
  endfunction
endclass

class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  env e0;
  uvm_sequence#(item) seq;
  virtual counter_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("e0", this);
    seq = item_seq::type_id::create("seq");
    if(!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif))
      `uvm_fatal("TEST", "Could not get VIF");
    uvm_config_db#(virtual counter_if)::set(this, "e0.a0.*", "counter_vif", vif);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    apply_reset();
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
  
  virtual task apply_reset();
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    @ (negedge vif.clk);
    vif.rst <= 0;
  endtask
  
endclass

class up_test extends base_test;
  `uvm_component_utils(up_test)
  
  function new(string name = "up_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = up_item_seq::type_id::create("seq");
  endfunction
endclass

class down_test extends base_test;
  `uvm_component_utils(down_test)
  
  function new(string name = "down_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = down_item_seq::type_id::create("seq");
  endfunction
endclass


module tb_top;
  logic clk;
  always #5 clk = ~clk;
  
  counter_if _if(clk);
  counter dut(
    .clk(clk), 
    .rst(_if.rst),
    .up(_if.up),
    .dout(_if.dout)
  );
  
  initial begin
    clk <=0;
    uvm_config_db#(virtual counter_if)::set(null, "*", "counter_vif", _if);
    run_test("up_test");  
  end
endmodule
