

module peripheral_core(
    peripheral_native_register_interface.in  reg_io,
    peripheral_memory_interface.in           mem_io,
    output  logic                            irq_out
    );


    // device registers (state that can be seen by a bus master)
    logic  [7:0]  data_out;     // Byte to write to bus
    logic  [7:0]  data_in;      // Byte read from bus
    
    logic  [31:0] read_length;  // # of bytes to read in FIFO mode
    logic  [31:0] write_length; // # of bytes to write in FIFO mode
    logic  [15:0] clk_divider;  // To set SCL frequency relative to peripheral clock
    logic         stop_ire;     // Interrupt enable for STOP condition
    logic         din_full_ire; // Interrupt enable for write FIFO full
    logic         din_empty_ire;// Interrupt enable for write FIFO empty AND bytes_written<write_length
    logic         dout_full_ire;// Interrupt enable for read FIFO full
    logic         ack_ire;      // Interrupt enable for slave ACK condition
    logic         nack_ire;     // Interrupt enable for slave NACK condition
    logic         bus_ire;      // Interrupt enable for bus available
    logic         arb_ire;      // Interrupt enable for arbitration loss
    logic         fifo_enable;  // Set to 1 to use FIFO 
    logic         packet_type;  // 0 for write, 1 for write-read
    logic         start;        // User sets to 1 to begin transaction
    logic         master_ACK;   // User sets to 1 to send ACK bit
    logic         master_NACK;  // User sets to 1 to send NACK bit
    logic         sr_enable;    // Enable repeated start: for slaves that use repeated start for reads

    logic         stop;         // Set to 1 at end of transaction - user writeable
    logic         din_full;     // Write FIFO full 
    logic         din_empty;    // Write FIFO empty AND bytes_written<write_length
    logic         dout_full;    // Read FIFO full 
    logic         slave_ACK;    // Set to 1 on ACK condition from slave 
    logic         slave_NACK;   // Set to 1 on NACK condition from slave
    logic         bus_available;// 1 when bus is available
    logic         arb_loss;     // Set to 1 after arbitration loss
    logic  [31:0] bytes_read;
    logic  [31:0] bytes_written;

    // hidden registers
    logic          irq;    // interrupt request


    // other internal logic signals
    logic  [31:0]  count_next;
    logic          en_next;
    logic          dir_next;
    logic          ire_next;
    logic          lt_1k_next;
    logic          irq_next;


    always_ff @(posedge reg_io.clk or posedge reg_io.reset) begin : register_logic
        if(reg_io.reset) begin
            // reset conditions
            count  <= 32'b0;
            en     <= 1'b0;
            dir    <= 1'b0;
            ire    <= 1'b0;
            lt_1k  <= 1'b0;
            irq    <= 1'b0;
        end else begin
            // default conditions
            count  <= count_next;
            en     <= en_next;
            dir    <= dir_next;
            ire    <= ire_next;
            lt_1k  <= lt_1k_next;
            irq    <= irq_next;
        end
    end


    always_comb begin : combinational_logic
        // default logic values
        irq_next   = 1'b0;                      // do not signal an interrupt
        count_next = count;                     // retain old count value
        en_next    = en;                        // retain old data
        dir_next   = dir;                       // retain old data
        ire_next   = ire;                       // retain old data
        lt_1k_next = lt_1k;                     // retain old data


        // count logic
        if(reg_io.count_we)
            count_next = reg_io.count_in;       // load new count from bus master
        else begin
            if(en) begin                        // if counting is enabled then
                if(dir)
                    count_next = count + 32'd1; // count up
                else
                    count_next = count - 32'd1; // count down
            end
        end


        // config logic
        if(reg_io.config_we) begin
            en_next  = reg_io.en_in;            // load new config value from bus master
            dir_next = reg_io.dir_in;           // load new config value from bus master
            ire_next = reg_io.ire_in;           // load new config value from bus master
        end


        // status logic
        lt_1k_next = count < 1000;              // set the less than 1000 status flag if the count is less than 1000


        // interrupt triggering logic
        if(ire && &count[15:0])                 // trigger an interrupt if interrupts are enabled and
            irq_next = 1'b1;                    // the lower 16 bits of the counter are set


        // assign output values
        reg_io.count_out = count;
        reg_io.en_out    = en;
        reg_io.dir_out   = dir;
        reg_io.ire_out   = ire;
        reg_io.lt_1k_out = lt_1k;
        irq_out          = irq;

    end


    // instantiate a single port memory
    single_port_memory  #(.DATAWIDTH(32), .DATADEPTH(256))
    single_port_memory(
        .clk       (mem_io.clk),
        .write_en  (mem_io.write_en),
        .data_in   (mem_io.data_in),
        .address   (mem_io.address),
        .data_out  (mem_io.data_out)
    );


endmodule

