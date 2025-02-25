`ifndef ENV_
	`define ENV_

class env extends uvm_env;

	agent             agent_h ;
	scoreboard        sb_h;
	subscriber        sub_h;
	user_config       conf_h;
	agent_rst         agent_rst_h;
	config_rst        conf_rst_h;
	virtual_sequencer v_seqr_h;


	`uvm_component_utils_begin(env)
	`uvm_component_utils_end


	// Constructor
	function new(string name = "env", uvm_component parent);
		super.new(name, parent);
	endfunction


	// build
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "Build phase of ENVIRONMENT", UVM_NONE)
		
		agent_h      = agent::type_id::create("agent_h",this);
		agent_rst_h  = agent_rst::type_id::create("agent_rst_h",this);
		sb_h         = scoreboard::type_id::create("sb_h",this);
		sub_h        = subscriber::type_id::create("sub_h",this);
		conf_h       = user_config::type_id::create("conf_h");
		conf_rst_h   = config_rst::type_id::create("conf_rst_h");
		v_seqr_h     = virtual_sequencer::type_id::create("v_seqr_h",this);

		conf_h.ape_h = UVM_ACTIVE;
		
		assert(conf_rst_h.randomize() with{ ape_rst_h == UVM_ACTIVE;
										delay == 500; });

		uvm_config_db #(user_config) :: set (this , "agent_h" , "CONFIG_KEY" , conf_h);
		uvm_config_db #(config_rst) :: set (this , "agent_rst_h" , "CONFIG_KEY_RST" , conf_rst_h);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent_h.mon_h.mon_put_port.connect(sb_h.score_imp_mon);
		agent_h.mon_h.mon_put_port.connect(sub_h.analysis_export);
		agent_h.drv_h.rsp_port.connect(sb_h.score_imp_driver);
		v_seqr_h.add_seqr = agent_h.seq_h;
		v_seqr_h.rst_seqr = agent_rst_h.seqr_rst_h;
	endfunction

endclass

`endif