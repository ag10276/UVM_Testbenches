module sync_fifo(
  input logic clk,
  input logic rst_n,
  input logic w_en,
  input logic r_en,
  input logic [7:0] wr_data,
  output logic [7:0] rd_data,
  output logic full,
  output logic empty
);
  
  logic [2:0] w_ptr, r_ptr;
  logic [7:0] fifo [7:0];
  logic [3:0] count;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      w_ptr <= 0;
    end
    else if(w_en && !full) begin
      fifo[w_ptr] <= wr_data;
      w_ptr <= w_ptr + 1;
    end
  end
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      r_ptr <= 0;
      rd_data <= 0;
    end
    else if(r_en && !empty) begin
      rd_data <= fifo[r_ptr];
      r_ptr <= r_ptr + 1;
    end
  end
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      count <= 0;
    end
    else begin
      case ({w_en && !full, r_en && !empty})
        2'b10: count <= count + 1; // write only
        2'b01: count <= count - 1; // read only
        2'b11: count <= count;     // simultaneous
        default: count <= count;   // idle
      endcase
    end
  end
  
  assign empty = (count == 0);
  assign full  = (count == 8);
  
endmodule

interface sync_fifo_if(input logic clk);
  logic rst_n;
  logic w_en;
  logic r_en;
  logic [7:0] wr_data;
  logic [7:0] rd_data;
  logic full;
  logic empty;
  
  clocking cb @(posedge clk);
    default input #1step output #0; 
    output rst_n, w_en, r_en, wr_data;
    input rd_data, full, empty;
  endclocking 
endinterface