`ifndef SUBSCRIBER_
	`define SUBSCRIBER_

class subscriber extends uvm_subscriber #(seq_item);


	`uvm_component_utils_begin(subscriber)
	`uvm_component_utils_end

	// uvm_analysis_imp #(seq_item,subscriber) sub_imp_mon;
	seq_item my_data;

	covergroup add_coverage ();
	   	data1_cp      : coverpoint my_data.data1;
	   	data2_cp      : coverpoint my_data.data2;
	   	sum_cp        : coverpoint my_data.data_out {
	   					ignore_bins all_one = {5'b1_1111};
	   	}
	   	ctrl_cp       : coverpoint my_data.ctrl {
	   					ignore_bins low = {0};
	   	}
	   	cross_data_cp : cross data1_cp,data2_cp,ctrl_cp;
	   	cross_sum_cp  : cross sum_cp,ctrl_cp;
	endgroup : add_coverage

	covergroup sub_coverage ();
	   	data1_cp      : coverpoint my_data.data1;
	   	data2_cp      : coverpoint my_data.data2;
	   	sub_cp        : coverpoint my_data.data_out {
	   					ignore_bins all_one = {[16:31]};
	   	}
	   	ctrl_cp       : coverpoint my_data.ctrl {
	   					ignore_bins low = {1};
	   	}
	   	cross_data1_data2_cp : cross data1_cp,data2_cp;

	  	cross_data_cp : cross data1_cp, data2_cp, ctrl_cp { 
    		bins all_zeros = binsof(ctrl_cp) intersect {0} && binsof(data1_cp) intersect {[0:15]} &&  binsof(data2_cp) intersect {[0:15]}; 
    		// bins data1      = binsof(data1_cp) intersect binsof(ctrl_cp);
    		// bins data2      = binsof(data2_cp) intersect binsof(ctrl_cp);
		}

	   	cross_sub_cp  : cross sub_cp,ctrl_cp;
	endgroup : sub_coverage


	// Constructor
	function new(string name = "subscriber", uvm_component parent);
		super.new(name, parent);
		// sub_imp_mon = new("sub_imp_mon",this);
		add_coverage = new();
		sub_coverage = new();
	endfunction


	// build
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "Build phase of SUBSCRIBER", UVM_NONE)
	endfunction

	function void write (seq_item t);
		`uvm_info("", "Data from subscriber", UVM_NONE)
		my_data = t;
		add_coverage.sample();
		sub_coverage.sample();
	endfunction : write

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_type_name(), "connect phase of SUBSCRIBER", UVM_NONE)
	endfunction : connect_phase

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), $sformatf("\n\n Coverage for instance add %s = %2.2f%%\n\n",this.get_full_name(),this.add_coverage.get_inst_coverage()), UVM_NONE)
		`uvm_info(get_type_name(), $sformatf("\n\n Coverage for instance sub %s = %2.2f%%\n\n",this.get_full_name(),this.sub_coverage.get_inst_coverage()), UVM_NONE)
	endfunction : report_phase

endclass

`endif