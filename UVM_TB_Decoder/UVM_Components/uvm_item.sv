class item extends uvm_sequence_item;
	`uvm_object_utils(item)

	function new(string name = "item");
		super.new(name);
	endfunction

	randc logic [2:0] a;
	logic [7:0] d;
  
  //constraint c_a {a inside {[0:3]};}
endclass