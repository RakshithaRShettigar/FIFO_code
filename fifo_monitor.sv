class fifo_monitor extends uvm_monitor;
  virtual fifo_interface vif;
  fifo_sequence_item item_got;
  uvm_analysis_port#(fifo_sequence_item) item_got_port;
  `uvm_component_utils(fifo_monitor)
  
  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name, parent);
    item_got_port = new("item_got_port", this);
  endfunction
  

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_got = fifo_sequence_item::type_id::create("item_got");
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Monitor: ", "No vif is found!")
  endfunction
      
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.m_mp.clk)
      if(vif.m_mp.m_cb.wr == 1)begin
        $display("\nwrite enable is high");
        item_got.data_in = vif.m_mp.m_cb.data_in;
        item_got.wr = 'b1;
        item_got.rd = 'b0;
        item_got.full = vif.m_mp.m_cb.full;
        item_got_port.write(item_got);
      end
      if(vif.m_mp.m_cb.rd == 1)begin
        @(posedge vif.m_mp.clk)
        $display("\nRD is high");
        item_got.data_out = vif.m_mp.m_cb.data_out;
        item_got.rd = 'b1;
        item_got.wr = 'b0;
        item_got.empty = vif.m_mp.m_cb.empty;
        item_got_port.write(item_got);
      end
    end
  endtask
endclass

    
