`ifndef DRIVER_RST_
	`define DRIVER_RST_

class driver_rst extends uvm_driver #(seq_item_rst);

	seq_item_rst itm_rst_h;

	virtual intf_rst vif_rst;

	`uvm_component_utils_begin(driver_rst)
	`uvm_component_utils_end

    static int driver_txn_count=0;

    config_rst conf_rst_h;

	function new(string name = "driver_rst", uvm_component parent);
		super.new(name, parent);
	endfunction


	// build
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if (uvm_config_db #(virtual intf_rst) :: get (this,"","INTERNAL_RESET_INTF",vif_rst)) begin 
			`uvm_info(get_type_name(), "Got intf from agent in driver", UVM_NONE)
		end else begin 
			`uvm_fatal(get_type_name(), "DRIVER INTF FATAL")
		end

		if (!uvm_config_db #(config_rst)::get(this,"","INTERNAL_REST_CONFIG",conf_rst_h))
			`uvm_fatal(get_full_name(), "Reset config not found!")
	endfunction

	// run
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(), "Run phase of driver", UVM_NONE)
		forever begin 
			#conf_rst_h.delay;
			seq_item_port.get_next_item(itm_rst_h);
				vif_rst.rst_in <= itm_rst_h.rst_in;
				itm_rst_h.rst_out = vif_rst.rst_out;
				seq_item_port.put_response(itm_rst_h);
				rsp_port.write(itm_rst_h);
			seq_item_port.item_done(itm_rst_h);
			driver_txn_count++;
		end
	endtask

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_full_name(), $sformatf("Total Number of transactions received in driver: %0d", driver_txn_count), UVM_NONE)
	endfunction

endclass

`endif