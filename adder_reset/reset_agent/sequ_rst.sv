class sequ_rst extends  uvm_sequence #(seq_item_rst);

	seq_item_rst itm_rst_h;

	`uvm_object_utils_begin(sequ_rst)
	`uvm_object_utils_end


	// Constructor
	function new(string name = "sequ_rst");
		super.new(name);
	endfunction

	virtual task body();
		repeat(1) begin
		// #1; 
			itm_rst_h = seq_item_rst::type_id::create("itm_rst_h");
			start_item(itm_rst_h);
			assert(itm_rst_h.randomize() with {rst_in == 1'b1;});
			finish_item(itm_rst_h);
			get_response(itm_rst_h);
			// itm_rst_h.print();
			`uvm_info(get_type_name(), "BODY OF SEQUENCE", UVM_NONE)
			response_queue_depth = 11;
		end
	endtask
endclass