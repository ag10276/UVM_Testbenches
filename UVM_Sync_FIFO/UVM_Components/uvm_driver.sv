class driver extends uvm_driver#(item);
  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual sync_fifo_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sync_fifo_if)::get(this, "", "sync_fifo_vif", vif))
      `uvm_fatal("DRV", "Virtual Interface not found!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item d_item;
      seq_item_port.get_next_item(d_item);
      @(vif.cb);
      vif.cb.rst_n <= d_item.rst_n;
      vif.cb.w_en <= d_item.w_en;
	  vif.cb.r_en <= d_item.r_en;
	  vif.cb.wr_data <= d_item.wr_data;
      //safeguards
//       if (d_item.w_en) begin
//     	if (!vif.cb.full)
//           `uvm_info("DRV", "Write allowed because FIFO is not FULL", UVM_MEDIUM)
//       	else
//       `uvm_error("DRV", "Write blocked because FIFO is FULL")
//   	  end

//       if (d_item.r_en) begin
//         if (!vif.cb.empty)
//           `uvm_info("DRV", "Read allowed because FIFO is not EMPTY", UVM_MEDIUM)
//         else
//           `uvm_error("DRV", "Read blocked because FIFO is EMPTY")
//       end
      seq_item_port.item_done();
    end
  endtask
endclass
