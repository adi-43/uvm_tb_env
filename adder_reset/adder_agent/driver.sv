`ifndef DRIVER_
	`define DRIVER_

class driver extends uvm_driver #(seq_item);

	parameter DATA_WIDTH = 4;

	virtual intf #(.DATA_WIDTH(DATA_WIDTH)) vif;

	seq_item seq;
	
	`uvm_component_utils_begin(driver)
	`uvm_component_utils_end

	// Constructor
	function new(string name = "driver", uvm_component parent);
		super.new(name, parent);
	endfunction 

	// build
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "Build phase of DRIVER", UVM_NONE)
		if (uvm_config_db #(virtual intf #(.DATA_WIDTH(DATA_WIDTH))) :: get (this,"","INTF_KEY",vif)) begin
			`uvm_info(get_type_name(), "RECEIVED in DRIVER",UVM_NONE)
		end else begin 
			`uvm_fatal(get_type_name(), "NOT RECEIVED in DRIVER")
		end
	endfunction

	// run
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin 
			#1;
			if (vif.rst_n) begin 
				seq_item_port.get_next_item(seq);
				`uvm_info(get_type_name(), "DATA PRINTING FROM DRIVER", UVM_NONE)
				// seq.print();
				// wait (vif.rst_n==1);
				drive_data(seq);
				seq_item_port.item_done(seq);
				`uvm_info(get_type_name(), "DATA passed to vif", UVM_NONE)
			end else begin 
				`uvm_info(get_type_name(), "Reset is LOW", UVM_NONE)
				@(posedge vif.clk);
			end
		end
	endtask

	task drive_data(seq_item  seq);
		@(posedge vif.clk);
		vif.data1 <= seq.data1;
		vif.data2 <= seq.data2;
		vif.ctrl  <= seq.ctrl;
		vif.en    <= 1'b1;
		@(posedge vif.clk);
		vif.en    <= 1'b0;
		@(posedge vif.clk);
		seq.data_out = vif.data_out;
		seq_item_port.put_response(seq);

		rsp_port.write(seq);
		seq.print();
	endtask : drive_data

endclass

`endif