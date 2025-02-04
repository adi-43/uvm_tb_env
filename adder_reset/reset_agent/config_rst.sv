`ifndef RESET_CONFIG_SVRST_
    `define RESET_CONFIG_SVRST_

class config_rst extends uvm_sequence_item ;

    rand uvm_active_passive_enum ape_rst_h;

    rand int delay = 70000;

    constraint delay_min { delay >= 0; }

    `uvm_object_utils_begin(config_rst)
        `uvm_field_enum (uvm_active_passive_enum, ape_rst_h , UVM_ALL_ON)
        `uvm_field_int (delay , UVM_ALL_ON)
    `uvm_object_utils_end

    // Constructor
    function new(string name = "config_rst");
        super.new(name);
        `uvm_info("", "Config class", UVM_NONE)
    endfunction

endclass
`endif