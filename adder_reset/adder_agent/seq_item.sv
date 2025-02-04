class seq_item extends uvm_sequence_item ;

	parameter DATA_WIDTH = 4;

	rand bit                  en;
	rand bit                  ctrl;
	rand bit [DATA_WIDTH-1:0] data1;
	rand bit [DATA_WIDTH-1:0] data2;
		 bit [DATA_WIDTH:0]   data_out;

		 constraint c1 {
		 	(ctrl == 0) -> (data1 >= data2); 	
		 }

		 constraint uniform_distribution {
        data1 dist { [0:15] :/ 16 };
        data2 dist { [0:15] :/ 16 };
    }

	// `uvm_object_utils(seq_item)
	`uvm_object_utils_begin(seq_item)
		`uvm_field_int (en,UVM_ALL_ON | UVM_DEC)
		`uvm_field_int (ctrl,UVM_ALL_ON | UVM_DEC)
		`uvm_field_int (data1,UVM_ALL_ON | UVM_DEC)
		`uvm_field_int (data2,UVM_ALL_ON | UVM_DEC)
		`uvm_field_int (data_out,UVM_ALL_ON | UVM_DEC)
	`uvm_object_utils_end


	// Constructor
	function new(string name = "seq_item");
		super.new(name);
	endfunction

	// function void control ();

	// 	if (ctrl) begin 
	// 		data_out = data1 + data2;
	// 	end else begin 
	// 		data_out = data1 - data2;
	// 	end
		
	// endfunction 

endclass