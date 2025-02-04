`ifndef SEQITEM_RST_
	`define SEQITEM_RST_

class seq_item_rst extends uvm_sequence_item ;

	rand bit rst_in;
		 bit rst_out;

	// `uvm_object_utils(seq_item_rst)
	`uvm_object_utils_begin(seq_item_rst)
		`uvm_field_int (rst_in,  UVM_ALL_ON)
		`uvm_field_int (rst_out, UVM_ALL_ON)
	`uvm_object_utils_end

	// Constructor
	function new(string name = "seq_item_rst");
		super.new(name);
	endfunction

endclass

`endif