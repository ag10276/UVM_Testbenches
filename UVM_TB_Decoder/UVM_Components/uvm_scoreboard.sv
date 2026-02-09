class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent);
		super.new(name, parent);
	endfunction

	uvm_analysis_imp #(item, scoreboard) scb_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		scb_imp = new("scb_imp", this);
	endfunction

	function void write(item s_item);
		case(s_item.a)
			3'b111: begin
				if(s_item.d == 8'b1000_0000) begin
					`uvm_info("SCB", "111: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b1000_0000, s_item.d))
				end
			end
			3'b110: begin
				if(s_item.d == 8'b0100_0000) begin
					`uvm_info("SCB", "110: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0100_0000, s_item.d))
				end
			end
			3'b101: begin
				if(s_item.d == 8'b0010_0000) begin
					`uvm_info("SCB", "101: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0010_0000, s_item.d))
				end
			end
			3'b100: begin
				if(s_item.d == 8'b0001_0000) begin
					`uvm_info("SCB", "100: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0001_0000, s_item.d))
				end
			end
			3'b011: begin
				if(s_item.d == 8'b0000_1000) begin
					`uvm_info("SCB", "011: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0000_1000, s_item.d))
				end
			end
			3'b010: begin
				if(s_item.d == 8'b0000_0100) begin
					`uvm_info("SCB", "010: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0000_0100, s_item.d))
				end
			end
			3'b001: begin
				if(s_item.d == 8'b0000_0010) begin
					`uvm_info("SCB", "001: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0000_0010, s_item.d))
				end
			end
			3'b000: begin
				if(s_item.d == 8'b0000_0001) begin
					`uvm_info("SCB", "000: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0000_0001, s_item.d))
				end
			end
			default: begin
				if(s_item.d == 8'b0000_0000) begin
					`uvm_info("SCB", "Default: Output as expected", UVM_NONE)
				end else begin
                  `uvm_error("SCB", $sformatf("Expected: %0b, Got: %0b", 8'b0000_0000, s_item.d))
				end
			end
		endcase
    endfunction
endclass