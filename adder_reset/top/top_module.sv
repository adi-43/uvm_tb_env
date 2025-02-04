`timescale 1ns/1ps

`include"uvm_macros.svh"
import uvm_pkg::*;

`include "test_pkg.sv"
import test_pkg::*;

`include "rtl.sv"
`include "interface.sv"
`include "intf_rst.sv"

module top_module;

	parameter DATA_WIDTH = 4;

	bit clk;

	initial begin 
		forever #5 clk = ~clk;
	end
	
	intf #(.DATA_WIDTH(DATA_WIDTH)) vif();
	intf_rst vif_rst();

	initial begin 
		uvm_config_db #(virtual intf #(.DATA_WIDTH(DATA_WIDTH))) :: set (null , "uvm_test_top.env_h.agent_h.mon_h" , "INTF_KEY" , vif);
		uvm_config_db #(virtual intf #(.DATA_WIDTH(DATA_WIDTH))) :: set (null , "uvm_test_top.env_h.agent_h.drv_h" , "INTF_KEY" , vif);
		uvm_config_db #(virtual intf_rst) :: set (null , "uvm_test_top.env_h.agent_rst_h" , "INTF_KEY_RST" , vif_rst);
		uvm_config_db #(virtual intf_rst) :: set (null , "uvm_test_top" , "INTF_KEY_RST_SEQ" , vif_rst);

		run_test("integrated_test");
	end


	assign vif.clk   = clk;
	assign vif.rst_n = vif_rst.rst_in;

	add_sub #
	(
		.DATA_WIDTH(DATA_WIDTH)
	) 
	inst_add_sub 
	(
		.clk      (vif.clk),
		.rst_n    (vif.rst_n),
		.en       (vif.en),
		.ctrl     (vif.ctrl),
		.data1    (vif.data1),
		.data2    (vif.data2),
		.data_out (vif.data_out)
	);


endmodule