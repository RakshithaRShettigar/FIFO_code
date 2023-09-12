class fifo_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(f_sequence_item, f_scoreboard) item_got_export;
  `uvm_component_utils(fifo_scoreboard)
  int counter;
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  int check_fifo[$];
  
  function void write(input f_sequence_item item_got);
    bit [127:0] testdata;
    if(item_got.i_wren == 'b1)begin
      if(check_fifo.size < 1023) begin
      counter = counter++;
      check_fifo.push_back(item_got.i_wrdata);
      `uvm_info("write Data", $sformatf("wr: %0b rd: %0b data_in: %0h full: %0b",item_got.wr, item_got.rd,item_got.data_in, item_got.full), UVM_LOW);
      end
      else begin
        $display("--------FIFO IS FULL--------"); 
      end
    end
    else if (item_got.i_rden == 'b1)begin
      if(check_fifo.size() >= 'd1)begin
        counter = counter--;
        testdata = check_fifo.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h data_out: %0h empty: %0b", examdata, item_got.data_out, item_got.empty), UVM_LOW);
        if(testdata == item_got.o_rddata)begin
          $display("--------MATCH SUCCESSFUL----------");
        end
        else begin
          $display("--------MATCH UNSUCCESSFUL--------");
        end
      end
      else begin
        $display("--------FIFO IS EMPTY--------");
      end
    end
  endfunction
endclass
        
