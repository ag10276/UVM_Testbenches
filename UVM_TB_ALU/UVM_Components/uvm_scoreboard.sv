class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp#(item, scoreboard) sb_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  logic [8:0] exp_y_comp;
  logic [7:0] exp_y;
  logic [3:0] exp_flags;
  
  function void write(item s_item);
    exp_y_comp = 9'b000000000;
    exp_y = 8'b00000000;
    exp_flags = 4'b0000;
    case(s_item.opcode)
      3'b000: begin
        exp_y_comp = {1'b0, s_item.a}+{1'b0, s_item.b};
        exp_y = exp_y_comp[7:0];
        exp_flags[1] = exp_y_comp[8];
        exp_flags[3] = (~s_item.a[7] & ~s_item.b[7] & exp_y[7]) | (s_item.a[7] & s_item.b[7] & ~exp_y[7]); 
      end
      3'b001: begin
        exp_y_comp = {1'b0, s_item.a}+{1'b0, ~s_item.b} +8'b1;
        exp_y = exp_y_comp[7:0];
        exp_flags[1] = exp_y_comp[8];
        exp_flags[3] = (s_item.a[7] & ~s_item.b[7] & ~exp_y[7]) | (~s_item.a[7] & s_item.b[7] & exp_y[7]); 
      end
      3'b010: begin
        exp_y = s_item.a & s_item.b;
      end
      3'b011: begin
        exp_y = s_item.a | s_item.b;
      end
      3'b100: begin
        exp_y = s_item.a ^ s_item.b;
      end
      3'b101: begin
        exp_y = ~s_item.a;
      end
      3'b110: begin
        exp_flags[1] = s_item.a[7];
        exp_y = s_item.a << 1;
      end
      3'b111: begin
        s_item.flags[1] = s_item.a[0];
        exp_y = s_item.a >> 1;
      end
    endcase
    exp_flags[0] = exp_y[7];
    exp_flags[2] = (exp_y == 8'b00000000);
    if(exp_y == s_item.y && exp_flags == s_item.flags) begin
          `uvm_info("SB", "Result as Expected", UVM_NONE);
        end else begin
          `uvm_error("SB", $sformatf("Debug Required -> opcode: %0b", s_item.opcode));
        end
  endfunction
endclass
