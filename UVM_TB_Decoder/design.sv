module decoder(
	input logic [2:0] a,
	output logic [7:0] d
);

	always_comb begin
		unique case(a)
		3'b111: d = 8'b1000_0000;
		3'b110: d = 8'b0100_0000;
		3'b101: d = 8'b0010_0000;
		3'b100: d = 8'b0001_0000;
		3'b011: d = 8'b0000_1000;
		3'b010: d = 8'b0000_0100;
		3'b001: d = 8'b0000_0010;
		3'b000: d = 8'b0000_0001;
		default: d = 8'b0000_0000;
		endcase
	end
endmodule

interface decoder_if;
logic [2:0] a;
logic [7:0] d;
endinterface
