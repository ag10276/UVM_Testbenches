class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual apb_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif))
      `uvm_fatal("DRV", "Virtual Interface not found!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    vif.drv_cb.PRESETn <= 1'b1;
    vif.drv_cb.PSEL    <= 1'b0;
    vif.drv_cb.PENABLE <= 1'b0;
    vif.drv_cb.PWRITE  <= 1'b0;
    vif.drv_cb.PADDR   <= '0;
    vif.drv_cb.PWDATA  <= '0;
    forever begin
      item d_item;
      seq_item_port.get_next_item(d_item);
      if (!d_item.PRESETn) begin
        // Reset cycle 
        @(vif.drv_cb);
        vif.drv_cb.PRESETn <= 1'b0;
        vif.drv_cb.PSEL    <= 1'b0;
        vif.drv_cb.PENABLE <= 1'b0;
      end else begin
        // SETUP phase
        @(vif.drv_cb);
        vif.drv_cb.PRESETn <= 1'b1;
        vif.drv_cb.PSEL    <= 1'b1;
        vif.drv_cb.PENABLE <= 1'b0;
        vif.drv_cb.PWRITE  <= d_item.PWRITE;
        vif.drv_cb.PADDR   <= d_item.PADDR;
        vif.drv_cb.PWDATA  <= d_item.PWDATA;

        //ACCESS phase
        @(vif.drv_cb);
        vif.drv_cb.PENABLE <= 1'b1;

        // Wait for PREADY
        @(vif.drv_cb);
        while (!vif.drv_cb.PREADY) @(vif.drv_cb);

        // Capture response into item so scoreboard can use it
        d_item.PRDATA  = vif.drv_cb.PRDATA;
        d_item.PREADY  = vif.drv_cb.PREADY;
        d_item.PSLVERR = vif.drv_cb.PSLVERR;

        // End of transfer
        vif.drv_cb.PENABLE <= 1'b0;
        vif.drv_cb.PSEL    <= 1'b0;
      end
      seq_item_port.item_done();
    end
  endtask
endclass
