class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual sync_fifo_if vif;
  uvm_analysis_port #(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sync_fifo_if)::get(this, "", "sync_fifo_vif", vif))
      `uvm_fatal("MON", "Virtual Interface not found!");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item = item::type_id::create("m_item");
      @(vif.cb);
      m_item.rst_n = vif.rst_n;
      m_item.w_en = vif.w_en;
      m_item.r_en = vif.r_en;
      m_item.wr_data = vif.wr_data;
      m_item.rd_data = vif.rd_data;
      m_item.full = vif.full;
      m_item.empty = vif.empty;
      `uvm_info("MON",
  $sformatf("rst_n=%0b w_en=%0b r_en=%0b wr_data=0x%0h rd_data=0x%0h full=%0b empty=%0b",
            m_item.rst_n, m_item.w_en, m_item.r_en,
            m_item.wr_data, m_item.rd_data,
            m_item.full, m_item.empty),
  UVM_LOW)
      mon_ap.write(m_item);
    end
  endtask
endclass
