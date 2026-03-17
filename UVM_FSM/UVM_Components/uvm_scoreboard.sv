class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  
  typedef enum int {EXP_SR, EXP_S0, EXP_S1, EXP_S2, EXP_S3} exp_state_e;
  exp_state_e exp_state;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
    exp_state = EXP_SR;
  endfunction
  
function void write(item s_item);
  
  logic [1:0] exp_NS, exp_EW;
  string state_name;
  
  if (s_item.reset) begin
      exp_state = EXP_SR;
    end
  case (exp_state)
      EXP_SR: begin
        exp_NS = 2'b00;
        exp_EW = 2'b00;
        state_name = "SR";
      end
      EXP_S0: begin
        exp_NS = 2'b10;
        exp_EW = 2'b00;
        state_name = "S0";
      end
      EXP_S1: begin
        exp_NS = 2'b01;
        exp_EW = 2'b00;
        state_name = "S1";
      end
      EXP_S2: begin
        exp_NS = 2'b00;
        exp_EW = 2'b10;
        state_name = "S2";
      end
      EXP_S3: begin
        exp_NS = 2'b00;
        exp_EW = 2'b01;
        state_name = "S3";
      end
      default: begin
        exp_NS = 2'b00;
        exp_EW = 2'b00;
        state_name = "UNKNOWN";
      end
    endcase
  
  if ((s_item.light_NS !== exp_NS) || (s_item.light_EW !== exp_EW)) begin
    `uvm_error("SB",
        $sformatf("FSM mismatch in %s: expected light_NS=%b light_EW=%b, got light_NS=%b light_EW=%b",
                  state_name, exp_NS, exp_EW, s_item.light_NS, s_item.light_EW))
    end
    else begin
      `uvm_info("SB",
        $sformatf("FSM match in %s: light_NS=%b light_EW=%b",
                  state_name, s_item.light_NS, s_item.light_EW),
        UVM_MEDIUM)
    end
  
  case (exp_state)
      EXP_SR: exp_state = EXP_S0;
      EXP_S0: exp_state = EXP_S1;
      EXP_S1: exp_state = EXP_S2;
      EXP_S2: exp_state = EXP_S3;
      EXP_S3: exp_state = EXP_S0;
      default: exp_state = EXP_SR;
    endcase
  
  
endfunction
  
endclass
