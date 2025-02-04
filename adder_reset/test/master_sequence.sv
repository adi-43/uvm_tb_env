class master_sequence extends uvm_sequence ;

	seqence add_seq_h;
	sequ_rst rst_seq_h;

	`uvm_object_utils_begin(master_sequence)
	`uvm_object_utils_end

	`uvm_declare_p_sequencer (virtual_sequencer)

	function new(string name = "master_sequence");
		super.new(name);
		add_seq_h = seqence::type_id::create("add_seq_h");
		rst_seq_h = sequ_rst::type_id::create("rst_seq_h");
	endfunction

	task body();
		rst_seq_h.start(p_sequencer.rst_seqr);
        `uvm_info("", "SEQUENCE 2", UVM_NONE)
		add_seq_h.start(p_sequencer.add_seqr);
        `uvm_info("", "SEQUENCE 1", UVM_NONE)
	endtask : body


endclass