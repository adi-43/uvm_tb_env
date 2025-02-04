`ifndef MONITOR_RST_
	`define MONITOR_RST_

class mon_rst extends uvm_monitor;

	uvm_analysis_port #(seq_item_rst) mon_put_port;
	virtual intf_rst vif_rst;

	seq_item_rst itm_rst_h;

	static int count = 0;

	`uvm_component_utils_begin(mon_rst)
	`uvm_component_utils_end

    config_rst conf_h;

	// Constructor
	function new(string name = "mon_rst", uvm_component parent);
		super.new(name, parent);
		mon_put_port = new("mon_put_port",this);
	endfunction


	// build
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (uvm_config_db #(virtual intf_rst) :: get (this,"","INTERNAL_RESET_INTF",vif_rst)) begin 
			`uvm_info(get_type_name(), "Got intf from agent in monitor", UVM_NONE)
		end else begin 
			`uvm_fatal(get_type_name(), "MONITOR INTF FATAL")
		end
		if (!uvm_config_db #(config_rst)::get(this,"","INTERNAL_REST_CONFIG",conf_h))
			`uvm_fatal(get_full_name(), "Reset config not found!")
	endfunction


	// run
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(), "Run phase of monitor", UVM_NONE)
		forever begin 
			// #1;
			#conf_h.delay;
			itm_rst_h=seq_item_rst::type_id::create("itm_rst_h");
			itm_rst_h.rst_in  = vif_rst.rst_in;
			itm_rst_h.rst_out = vif_rst.rst_out;
			mon_put_port.write(itm_rst_h);
			count++;
		end
	endtask


	// report
	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), $sformatf("total number of Transactions from monitor : %0d",count), UVM_NONE)
	endfunction

endclass

`endif