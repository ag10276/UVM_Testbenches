module traffic_light_controller (
    input logic clk, reset,
    output logic [1:0] light_NS, light_EW 
);

  typedef enum logic [2:0] {S0 = 0, S1 = 1, S2 = 2, S3 = 3, SR = 4} state_e;


state_e state, next;


always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
		state <= SR;
    end else begin
      state <= next;
    end
  end


always_comb begin
    case (state)
      S0: begin
        light_NS = 2'b10;
        light_EW = 2'b00;
        next = S1;
      end
      S1: begin
        light_NS = 2'b01;
        light_EW = 2'b00;
        next = S2;
      end
      S2: begin
        light_NS = 2'b00;
        light_EW = 2'b10;
        next = S3;
      end
      S3: begin
        light_NS = 2'b00;
        light_EW = 2'b01;
        next = S0;
      end
      SR: begin
        light_NS = 2'b00;
    	light_EW = 2'b00;
    	next = S0;
      end
      default: begin
        light_NS = 2'b00;
    	light_EW = 2'b00;
    	next = S0;
      end
    endcase
  end

endmodule

interface fsm_if(input logic clk);
  logic reset;
  logic [1:0] light_NS; 
  logic [1:0] light_EW;
  
  clocking cb @(posedge clk);
    default input #1step output #0; 
    output reset;
    input light_NS, light_EW;
  endclocking
endinterface