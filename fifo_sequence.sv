class fifo_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(f_sequence)
  
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("-------------Performing continuous write operation------------"), UVM_LOW)
    repeat(1024) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {{wr,rd} == 10;});
      finish_item(req);
    end
    `uvm_info(get_type_name(), $sformatf(""-------------Performing continuous read operation------------"), UVM_LOW)
    repeat(16) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {{i_wren,i_rden} == 01;});
      finish_item(req);
    end
    `uvm_info(get_type_name(), $sformatf("******** Generate 20 Random REQs ********"), UVM_LOW)
    repeat(20) begin
      req = f_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
  
endclass
  
  
