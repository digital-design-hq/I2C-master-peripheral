

// register map
// address //   bits    //  registers       // type   //  access type  // value meaning
//       0      [7:0]       data out           data       read/write    For FIFOless use
//       1      [7:0]       data in            data       read only     For FIFOless use

//       2      [31:0]      read length        config     read/write    (# of bytes to read before NACK-STOP condition)
//       3      [15:0]      clock divider      config     read/write    
//       4      [7:0]       Interrupt enables  config     read/write    (1 for enabled: same bit map as status reg)
//       4      [8]         FIFO enable        config     read/write    (1 to use FIFO - or when DMA is used)
//       4      [9]         transmission type  config     read/write    (0 for write only, 1 for write-read)
//       4      [10]        repeated start     config     read/write    (1 for a repeated start on write-read operations)

//       5      [0]         Operation finished status     read/write    (gets set to 1, user clears)
//       5      [1]         Write FIFO full    status     read/write    (gets set to 1, user clears)
//       5      [2]         Write FIFO empty   status     read/write    (gets set to 1, user clears)
//       5      [3]         Read FIFO full     status     read/write    (gets set to 1, user clears)
//       5      [4]         ACK                status     read/write    (gets set to 1 if FIFO enable=0, user clears)
//       5      [5]         NACK               status     read/write    (gets set to 1 if FIFO enable=0, user clears)
//       5      [6]         Bus status         status     read only     (1 for available, 0 for in use)
//       5      [7]         Arbitration loss   status     read only     (1 for arbitration loss)


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

