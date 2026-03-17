module apb_memory(
  input  logic PCLK,
  input  logic PRESETn,
  input  logic [31:0]  PADDR,
  input  logic [31:0] PWDATA,
  input  logic PSEL,
  input  logic PENABLE,
  input  logic PWRITE,
  output logic [31:0] PRDATA,
  output logic PREADY,
  output logic PSLVERR
);
  logic [31:0] mem [31:0];
  typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
  state_t state, next_state;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) state <= IDLE;
    else state <= next_state;
  end

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      for (int i = 0; i < 32; i++)
        mem[i] <= '0;
    end else if (state == ACCESS && PSEL && PENABLE && PWRITE && !PADDR[5]) begin
      mem[PADDR[4:0]] <= PWDATA;
    end
  end

  always_comb begin
    next_state = state;
    PREADY     = 1'b0;
    PRDATA     = '0;
    PSLVERR    = 1'b0;

    case (state)
      IDLE: begin
        if (PSEL) next_state = SETUP;
        else next_state = IDLE;
      end

      SETUP: begin
        next_state = ACCESS;
      end

      ACCESS: begin
        PREADY  = 1'b1;
        PSLVERR = PADDR[5];
        if (PSEL && PENABLE && !PWRITE && !PADDR[5])
          PRDATA = mem[PADDR[4:0]];
        next_state = PSEL ? SETUP : IDLE;
      end

      default: next_state = IDLE;
    endcase
  end
endmodule

interface apb_if(input logic PCLK);
  logic PRESETn;
  logic [31:0]  PADDR;
  logic [31:0] PWDATA;
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [31:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  
  clocking drv_cb @(posedge PCLK);
    default input #1step output #0; 
    output PRESETn, PADDR, PWDATA, PSEL, PENABLE, PWRITE;
    input PRDATA, PREADY, PSLVERR;
  endclocking 
  
  clocking mon_cb @(posedge PCLK);
    default input #1step output #0; 
    input PRESETn, PADDR, PWDATA, PSEL, PENABLE, PWRITE, PRDATA, PREADY, PSLVERR;
  endclocking 
  
endinterface