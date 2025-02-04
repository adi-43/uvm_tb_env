`ifndef AGENT_RST_
	`define AGENT_RST_

class agent_rst extends uvm_agent;

	sequencer_rst seqr_rst_h;
	driver_rst    drv_rst_h;
	mon_rst       mon_rst_h;
	config_rst    conf_rst_h;

	virtual intf_rst vif_rst;


	`uvm_component_utils_begin(agent_rst)
	`uvm_component_utils_end


	// Constructor
	function new(string name = "agent_rst", uvm_component parent);
		super.new(name, parent);
	endfunction


	// build
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if (uvm_config_db #(virtual intf_rst) :: get (this,"","INTF_KEY_RST",vif_rst)) begin 
            uvm_pkg::uvm_config_db#(virtual intf_rst)::set(this, "drv_rst_h", "INTERNAL_RESET_INTF", vif_rst);
            uvm_pkg::uvm_config_db#(virtual intf_rst)::set(this, "mon_rst_h", "INTERNAL_RESET_INTF", vif_rst);
			`uvm_info(get_type_name(), "Got intf from top in agent", UVM_NONE)
		end else begin 
			`uvm_fatal(get_type_name(), "AGENT INTF FATAL")
		end

		if (uvm_config_db #(config_rst) :: get(this,"","CONFIG_KEY_RST",conf_rst_h)) begin 
			 uvm_config_db #(config_rst)::set(this, "drv_rst_h", "INTERNAL_REST_CONFIG", conf_rst_h);
           uvm_config_db #(config_rst)::set(this, "mon_rst_h", "INTERNAL_REST_CONFIG", conf_rst_h);
		end else begin
            `uvm_fatal(get_full_name(), "reset_config class not received")
        end

        if(conf_rst_h.ape_rst_h == UVM_ACTIVE) begin
            seqr_rst_h = sequencer_rst::type_id::create("seqr_rst_h",this);
			drv_rst_h  = driver_rst::type_id::create("drv_rst_h",this);
        end
        mon_rst_h = mon_rst::type_id::create("mon_rst_h",this);
		`uvm_info(get_type_name(), "Build phase of agnt", UVM_NONE)

	endfunction

	// connect
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(conf_rst_h.ape_rst_h == UVM_ACTIVE) begin
			drv_rst_h.seq_item_port.connect(seqr_rst_h.seq_item_export);
		end
		`uvm_info(get_type_name(), "connect phase of agent", UVM_NONE)
	endfunction

endclass

`endif