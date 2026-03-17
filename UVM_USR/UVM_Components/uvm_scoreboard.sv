class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  logic exp_serial_out_right;
  logic exp_serial_out_left;
  logic [7:0] exp_parallel_out, exp_output;
  
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    exp_parallel_out = 'b0;
  endfunction
  
  uvm_analysis_imp #(item, scoreboard) sb_imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  function automatic logic[7:0] next_output(item txn, logic[7:0] curr);
    if(txn.clr) begin
      return 8'b0;
    end else begin
      case(txn.control)
        2'b00: return curr;
        2'b01: return{txn.serial_in_left, curr[7:1]}; //right shift
        2'b10: return{curr[6:0], txn.serial_in_right}; //left shift
        2'b11: return txn.parallel_in; //parallel
        default: begin
        end
      endcase
    end
  endfunction
  
  int unsigned cycle_cnt = 0;

function string mode_str(logic [1:0] ctrl);
  case (ctrl)
    2'b00: return "HOLD";
    2'b01: return "RSHIFT";
    2'b10: return "LSHIFT";
    2'b11: return "PARLOAD";
    default: return "UNKNOWN";
  endcase
endfunction


function void write(item s_item);
  cycle_cnt++;

  // Compute expected
  exp_output = next_output(s_item, exp_parallel_out);
  exp_serial_out_right = exp_output[0];
  exp_serial_out_left  = exp_output[7];

  // Check parallel_out
  if (s_item.parallel_out !== exp_output) begin
    `uvm_error("SB",
      $sformatf(
        "Cycle %0d [%s] parallel_out mismatch | prev=%0h exp=%0h act=%0h",
        cycle_cnt,
        mode_str(s_item.control),
        exp_parallel_out,
        exp_output,
        s_item.parallel_out
      )
    )
  end

  // Check serial_out_right
  if (s_item.serial_out_right !== exp_serial_out_right) begin
    `uvm_error("SB",
      $sformatf(
        "Cycle %0d [%s] serial_out_right mismatch | exp=%0b act=%0b",
        cycle_cnt,
        mode_str(s_item.control),
        exp_serial_out_right,
        s_item.serial_out_right
      )
    )
  end

  // Check serial_out_left
  if (s_item.serial_out_left !== exp_serial_out_left) begin
    `uvm_error("SB",
      $sformatf(
        "Cycle %0d [%s] serial_out_left mismatch | exp=%0b act=%0b",
        cycle_cnt,
        mode_str(s_item.control),
        exp_serial_out_left,
        s_item.serial_out_left
      )
    )
  end
  
  // Update expected state
  exp_parallel_out = exp_output;
endfunction
  
endclass
