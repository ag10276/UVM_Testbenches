class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual apb_if vif;
  uvm_analysis_port #(item) mon_ap;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif))
      `uvm_fatal("MON", "Virtual Interface not found!");
    mon_ap = new("mon_ap", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item;
      @(vif.mon_cb);

      // Capture reset 
      if (!vif.mon_cb.PRESETn) begin
        m_item = item::type_id::create("m_item");
        m_item.PRESETn  = 1'b0;
        m_item.PSEL     = 1'b0;
        m_item.PENABLE  = 1'b0;
        m_item.PWRITE   = 1'b0;
        m_item.PADDR    = '0;
        m_item.PWDATA   = '0;
        m_item.PRDATA   = vif.mon_cb.PRDATA;
        m_item.PREADY   = vif.mon_cb.PREADY;
        m_item.PSLVERR  = vif.mon_cb.PSLVERR;
        `uvm_info("MON", $sformatf("RESET observed | PRDATA=0x%08h PREADY=%0b PSLVERR=%0b",
          m_item.PRDATA, m_item.PREADY, m_item.PSLVERR), UVM_LOW)
        mon_ap.write(m_item);

      // Capture completed ACCESS phase
      end else if (vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY) begin
        m_item           = item::type_id::create("m_item");
        m_item.PRESETn   = vif.mon_cb.PRESETn;
        m_item.PWRITE    = vif.mon_cb.PWRITE;
        m_item.PADDR     = vif.mon_cb.PADDR;
        m_item.PWDATA    = vif.mon_cb.PWDATA;
        m_item.PRDATA    = vif.mon_cb.PRDATA;
        m_item.PREADY    = vif.mon_cb.PREADY;
        m_item.PSLVERR   = vif.mon_cb.PSLVERR;
        `uvm_info("MON", m_item.convert2string(), UVM_LOW)
        mon_ap.write(m_item);
      end
    end
  endtask
endclass
