`ifndef MONITOR_
	`define MONITOR_

class monitor extends uvm_monitor;


	seq_item itm_h;
	

	uvm_analysis_port #(seq_item) mon_put_port;

	parameter DATA_WIDTH = 4;

	virtual intf #(.DATA_WIDTH(DATA_WIDTH)) vif;

	static int count = 0;

	// `uvm_component_utils(monitor)
	`uvm_component_utils_begin(monitor)
	/**** `uvm_field_* macro invocations here ****/
	`uvm_component_utils_end

	// Constructor
	function new(string name = "monitor", uvm_component parent);
		super.new(name, parent);
		mon_put_port = new("mon_put_port", this);
	endfunction

	// build
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "Build phase of MONITOR", UVM_NONE)		
		if (uvm_config_db #(virtual intf #(.DATA_WIDTH(DATA_WIDTH))) :: get (this,"","INTF_KEY",vif)) begin 
			`uvm_info(get_type_name(), "RECEIVED in MONITOR",UVM_NONE)
		end else begin 
			`uvm_fatal(get_type_name(), "NOT RECEIVED in MONITOR")
		end
	endfunction

	// run
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin 
			// #1;
			if (vif.rst_n) begin 
				monitor_data();
			end else begin
				`uvm_info(get_type_name(), "Reset is driving zero!", UVM_NONE)
				@(posedge vif.clk);
			end
		end
	endtask

	task monitor_data();
		itm_h=seq_item::type_id::create("itm_h");
		@(posedge vif.clk);
		if (vif.en) begin 
			count++;
			itm_h.data1    = vif.data1;
			itm_h.data2    = vif.data2;
			itm_h.en       = vif.en;
			itm_h.ctrl     = vif.ctrl;
			itm_h.data_out = vif.data_out;
			mon_put_port.write(itm_h);
			`uvm_info(get_type_name(),"MONITOR WRITING DATA", UVM_NONE)			
		end else begin 
			`uvm_info(get_type_name(),"Enable is LOW", UVM_NONE)
		end
	endtask

	function void report_phase (uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), $sformatf("total number of Transactions from monitor : %0d",count), UVM_NONE)
	endfunction : report_phase

endclass

`endif