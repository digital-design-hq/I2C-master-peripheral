

// register map
// address //   bits    //  registers       // type   //  access type  // value meaning
//       0      [7:0]       data out           data       read/write    For FIFO or DMAless use
//       1      [7:0]       data in            data       read only     For FIFO or DMAless use
//       2      [31:0]      DMA read start     data       read/write    Address to get data to send in DMA mode
//       3      [31:0]      DMA read stop      data       read/write    -should these be in the DMA module?
//       4      [31:0]      DMA write start    data       read/write    Address to store recieved data in DMA mode
//       5      [31:0]      DMA write stop     data       read/write    -if they are in the DMA module, should they have addresses at the end?

//       6      [15:0]      clock divider      config     read/write    
//       7      [5:0]       Interrupt enables  config     read/write    (1 for enabled: same bit map as status reg)
//       7      [6]         FIFO enable        config     read/write    (1 to use FIFO - takes precedence over DMA)
//       7      [7]         DMA  enable        config     read/write    (1 to use DMA)
//       7      [8]         transmission type  config     read/write    (0 for write only, 1 for write-read)

//       8      [0]         Operation finished status     read/write    (gets set to 1, user clears)
//       8      [1]         Write FIFO full    status     read/write    (gets set to 1, user clears)
//       8      [2]         Write FIFO empty   status     read/write    (gets set to 1, user clears)
//       8      [3]         Read FIFO full     status     read/write    (gets set to 1, user clears)
//       8      [4]         ACK                status     read/write    (gets set to 1 if FIFO/DMA enable=0, user clears)
//       9      [5]         NACK               status     read/write    (gets set to 1 if FIFO/DMA enable=0, user clears)
//       8      [6]         Bus status         status     read only     (1 for available, 0 for in use)
//       8      [7]         Arbitration loss   status     read only     (1 for arbitration loss)


module peripheral_register_map(
    peripheral_register_interface.in          reg_adapter_io,
    peripheral_native_register_interface.out  reg_io
    );


    // this is a known value so we preset it correctly.
    parameter REGS             = 3;
    parameter POWEROF2REGS     = $clog2(REGS) ** 2;


    // assign resets and clocks
    assign reg_io.clk   = reg_adapter_io.clk;
    assign reg_io.reset = reg_adapter_io.reset;


    // map native registers to generic register array of bus adapter
    always_comb begin
        // defaults
        reg_adapter_io.data_out          = '{POWEROF2REGS{32'b0}};        // set all output lines to zero


        // counter register mapping
        reg_io.count_we                  = reg_adapter_io.write_en[0];    // write enable map
        reg_io.count_in                  = reg_adapter_io.data_in [31:0]; // input map
        reg_adapter_io.data_out[0][31:0] = reg_io.count_out;              // output map


        // config register mapping
        reg_io.config_we                 = reg_adapter_io.write_en[1];    // write enable map
        reg_io.en_in                     = reg_adapter_io.data_in [0];    // input map
        reg_io.dir_in                    = reg_adapter_io.data_in [1];    // input map
        reg_io.ire_in                    = reg_adapter_io.data_in [2];    // input map
        reg_adapter_io.data_out[1][0]    = reg_io.en_out;                 // output map
        reg_adapter_io.data_out[1][1]    = reg_io.dir_out;                // output map
        reg_adapter_io.data_out[1][2]    = reg_io.ire_out;                // output map


        // status register mapping
        reg_adapter_io.data_out[2][0]    = reg_io.lt_1k_out;              // output map
    end


endmodule

