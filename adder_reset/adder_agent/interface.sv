`ifndef INTF_
	`define INTF_

`timescale 1ns/1ps

interface intf # (parameter DATA_WIDTH = 4);

    bit                  en;
	bit                  ctrl;
	bit [DATA_WIDTH-1:0] data1;
	bit [DATA_WIDTH-1:0] data2;
	bit [DATA_WIDTH:0]   data_out;
	bit                  clk;
	bit                  rst_n;

endinterface

`endif