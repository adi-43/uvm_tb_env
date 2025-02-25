`include "rst_agent_pkg.sv"
`include "adder_agent_pkg.sv"

package env_pkg;

	import uvm_pkg::*;
	
	import rst_agent_pkg::*;
	import adder_agent_pkg::*;

	typedef class env;
	typedef class scoreboard;
	typedef class subscriber;
	typedef class virtual_sequencer;

	`include "env.sv"
	`include "subscriber.sv"
	`include "scoreboard.sv"
	`include "virtual_sequencer.sv"

endpackage