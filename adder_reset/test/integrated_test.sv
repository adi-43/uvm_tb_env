class integrated_test extends uvm_test ;

	env env_h;
	master_sequence m_seq_h;

	virtual intf_rst vif_rst;

	`uvm_component_utils_begin(integrated_test)
	/**** `uvm_field_* macro invocations here ****/
	`uvm_component_utils_end

	// Constructor
	function new(string name = "integrated_test", uvm_component parent);
		super.new(name, parent);
	endfunction


	// build
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h =env::type_id::create("env_h",this);
	endfunction

	// end_of_elaboration
	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		if (uvm_config_db #(virtual intf_rst) :: get (this,"","INTF_KEY_RST_SEQ",vif_rst)) begin 
			`uvm_info(get_type_name(), "Got intf from top in sequence", UVM_NONE)
		end else begin 
			`uvm_fatal(get_type_name(), "SEQUENCE INTF FATAL")
		end
		uvm_root::get().print_topology();

	endfunction

	// run
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		m_seq_h=master_sequence::type_id::create("m_seq_h");
		m_seq_h.start(env_h.v_seqr_h);
	// 	fork
    //     begin
    //         forever begin
    //             if (s_h.count == 51) begin
    //                 assert (vif_rst.rst_in == 0)
    //                     else `uvm_error("RST_IN_CHECK", "vif_rst.rst_in is not 0 when count == 51");
    //             end else begin
    //                 assert (vif_rst.rst_in == 1)
    //                     else `uvm_error("RST_IN_CHECK", "vif_rst.rst_in is not 1 when count != 51");
    //             end
    //             #1;
    //         end
    //     end
    // join_none
			phase.drop_objection(this);
		endtask

endclass
		// assert property (
		//     // @(posedge clk) 
		//     (s_h.count == 51) |-> (vif_rst.rst_in == 0 ##1 vif_rst.rst_in == 1)
		// ) else $error("rst_in does not behave as expected when count == 51.");

		// assert ((vif_rst.rst_in == 0) with { s_h.count == 50;});

		// assert ((vif_rst.rst_in == 0) && (s_h.count == 50));

		// assert (s_h.count == 51) |-> (vif_rst.rst_in == 0 ##1 vif_rst.rst_in == 1);

		// assert(conf_rst_h.randomize() with{ ape_rst_h == UVM_ACTIVE;
		// 								delay == 500; });