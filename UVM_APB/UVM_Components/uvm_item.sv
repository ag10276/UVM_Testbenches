class item extends uvm_sequence_item;
  `uvm_object_utils(item)
  
  function new(string name = "item");
    super.new(name);
  endfunction

  rand bit PRESETn;
  rand bit [31:0] PADDR;
  rand bit [31:0] PWDATA;
  rand bit PWRITE;
  
  bit PSEL;
  bit PENABLE;
  
  bit [31:0] PRDATA;
  bit PREADY;
  bit PSLVERR;
  
  constraint c_reset { PRESETn dist { 1'b1 := 9, 1'b0 := 1 }; }
  constraint c_addr  { PADDR dist { [6'h00:6'h1F] := 7, [6'h20:6'h3F] := 3 }; }
  
  function string convert2string();
    return $sformatf(
      "PRESETn=%0b PWRITE=%0b PADDR=0x%02h PWDATA=0x%08h | PRDATA=0x%08h PREADY=%0b PSLVERR=%0b",
      PRESETn, PWRITE, PADDR, PWDATA, PRDATA, PREADY, PSLVERR);
  endfunction
endclass
