`ifndef SEQUENCER_RST_
    `define SEQUENCER_RST_

class sequencer_rst extends uvm_sequencer #(seq_item_rst);

    `uvm_component_utils_begin(sequencer_rst)
    `uvm_component_utils_end

    function new(string name = "sequencer_rst", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

`endif