

// register map
// address //   bits    //  registers       // type   //  access type  // value meaning
//       0      [7:0]       data out           data       read/write    For FIFOless use (to write on bus)
//       1      [7:0]       data in            data       read only     For FIFOless use (Read from bus)

//       2      [31:0]      read length        config     read/write    (# of bytes to read before NACK-STOP condition)
//       3      [31:0]      write length       config     read/write    (# of bytes to write before STOP)
//       4      [15:0]      clock divider      config     read/write    (divider to set SCL frequency based on peripheral clock)
//       5      [7:0]       Interrupt enables  config     read/write    (1 for enabled: same bit map as status reg)
//       5      [8]         FIFO enable        config     read/write    (1 to use FIFO - or when DMA is used)
//       5      [9]         transmission type  config     read/write    (0 for write, 1 for write-read OR read in FIFOless mode)
//       5      [10]        START              config     read/write    (user sets to 1 to start the transaction)
//       5      [11]        master ACK         config     read/write    (user sets to 1 to send ACK bit)
//       5      [12]        master NACK        config     read/write    (user sets to 1 to send NACK bit
//       5      [13]        repeated start     config     read/write    (1 for a repeated start on write-read operations)

//       6      [0]         STOP               status     read/write    (gets set to 1, user clears OR user sets in FIFOless mode)
//       6      [1]         Write FIFO full    status     read/write    (gets set to 1, user clears)
//       6      [2]         Write FIFO empty   status     read/write    (gets set to 1, user clears)
//       6      [3]         Read FIFO full     status     read/write    (gets set to 1, user clears)
//       6      [4]         slave ACK          status     read/write    (gets set to 1 if FIFO enable=0, user clears)
//       6      [5]         slave NACK         status     read/write    (gets set to 1 if FIFO enable=0, user clears)
//       6      [6]         Bus status         status     read only     (1 for available, 0 for in use)
//       6      [7]         Arbitration loss   status     read only     (1 for arbitration loss)
//       7      [31:0]      Bytes read         status     read only     
//       8      [31:0]      Bytes written      status     read only


module peripheral_register_map(
    peripheral_register_interface.in          reg_adapter_io,
    peripheral_native_register_interface.out  reg_io
    );


    // this is a known value so we preset it correctly.
    parameter REGS             = 9;
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

