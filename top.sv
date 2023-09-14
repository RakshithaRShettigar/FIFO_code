`include "fifo_sequence_item.sv"
`include "fifo_sequence.sv"
`include "fifo_driver.sv"
`include "fifo_sequencer.sv"
`include "fifo_monitor.sv"
`include "fifo_  

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "f_interface.sv"
`include "f_test.sv"

module tb;
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 1;
    reset = 1;
    #5;
    reset = 0;
  end
  
  f_interface tif(clk, reset);
  
  SYN_FIFO dut(.clk(tif.clk),
               .rstn(tif.reset),
               .i_wrdata(tif.data_in),
               .i_wren(tif.i_wren),
               .i_rden(tif.i_rden),
               .o_full(tif.o_full),
               .o_empty(tif.o_empty),
               .o_rddata(tif.o_rddata));
  
  initial begin
    uvm_config_db#(virtual f_interface)::set(null, "", "vif", tif);
    $dumpfile("dump.vcd"); 
    $dumpvars;
    run_test("f_test");
  end
  
endmodule