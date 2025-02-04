`timescale 1ns/1ps

module add_sub #(parameter DATA_WIDTH = 4)
(
	input logic                   clk,
	input logic                   rst_n,
	input logic                   en,
	input logic                   ctrl,
	input logic  [DATA_WIDTH-1:0] data1,
	input logic  [DATA_WIDTH-1:0] data2,
	output logic [DATA_WIDTH:0]   data_out
 );

always_ff @ (posedge clk, negedge rst_n) begin 
	if (!rst_n) begin 
		data_out <= 0;
	end else if (en) begin 
		if (ctrl) begin 
			data_out <= data1 + data2;
		end else begin 
			data_out <= data1 - data2;
		end
	end
end

endmodule