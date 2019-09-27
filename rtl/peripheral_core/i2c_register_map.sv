

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
//       7      [31:0]      Bytes read         status     read only     (in current transaction)
//       8      [31:0]      Bytes written      status     read only


module i2c_register_map(
    i2c_register_interface.in          reg_adapter_io,
    i2c_native_register_interface.out         reg_io
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


        // data register mapping
        reg_io.data_out_we               = reg_adapter_io.write_en[0];    // write enable map
        
        reg_io.data_out_in              = reg_adapter_io.data_in [8:0]; // input map
               
        reg_adapter_io.data_out[0][7:0] = reg_io.data_out_out;              // output map
        reg_adapter_io.data_out[1][7:0] = reg_io.data_in_out;

        
        // config register mapping
        reg_io.read_length_we            = reg_adapter_io.write_en[2]; //write enable map
        reg_io.write_length_we           = reg_adapter_io.write_en[3];
        reg_io.clk_divider_we            = reg_adapter_io.write_en[4];
        reg_io.config_we                 = reg_adapter_io.write_en[5];
        
        reg_io.read_length_in           = reg_adapter_io.data_in [31:0];    //input map
        reg_io.write_length_in          = reg_adapter_io.data_in [31:0];
        reg_io.clk_divider_in           = reg_adapter_io.data_in [15:0];
        reg_io.stop_ire_in              = reg_adapter_io.data_in [0];
        reg_io.din_full_ire_in          = reg_adapter_io.data_in [1];
        reg_io.din_empty_ire_in         = reg_adapter_io.data_in [2];
        reg_io.dout_full_ire_in         = reg_adapter_io.data_in [3];
        reg_io.ack_ire_in               = reg_adapter_io.data_in [4];
        reg_io.nack_ire_in              = reg_adapter_io.data_in [5];
        reg_io.bus_ire_in               = reg_adapter_io.data_in [6];
        reg_io.arb_ire_in               = reg_adapter_io.data_in [7];
        reg_io.fifo_enable_in           = reg_adapter_io.data_in [8];
        reg_io.packet_type_in           = reg_adapter_io.data_in [9];
        reg_io.start_in                 = reg_adapter_io.data_in [10];
        reg_io.master_ACK_in            = reg_adapter_io.data_in [11];
        reg_io.master_NACK_in           = reg_adapter_io.data_in [12];
        reg_io.sr_enable_in             = reg_adapter_io.data_in [13];


        reg_adapter_io.data_out[2][31:0] = reg_io.read_length_out;
        reg_adapter_io.data_out[3][31:0] = reg_io.write_length_out;
        reg_adapter_io.data_out[4][15:0] = reg_io.clk_divider_out;
        reg_adapter_io.data_out[5][0]    = reg_io.stop_ire_out;
        reg_adapter_io.data_out[5][1]    = reg_io.din_full_ire_out;
        reg_adapter_io.data_out[5][2]    = reg_io.din_empty_ire_out;
        reg_adapter_io.data_out[5][3]    = reg_io.dout_full_ire_out;
        reg_adapter_io.data_out[5][4]    = reg_io.ack_ire_out;
        reg_adapter_io.data_out[5][5]    = reg_io.nack_ire_out;
        reg_adapter_io.data_out[5][6]    = reg_io.bus_ire_out;
        reg_adapter_io.data_out[5][7]    = reg_io.arb_ire_out;
        reg_adapter_io.data_out[5][8]    = reg_io.fifo_enable_out;
        reg_adapter_io.data_out[5][9]    = reg_io.packet_type_out;
        reg_adapter_io.data_out[5][10]   = reg_io.start_out;
        reg_adapter_io.data_out[5][11]   = reg_io.master_ACK_out;
        reg_adapter_io.data_out[5][12]   = reg_io.master_NACK_out;
        reg_adapter_io.data_out[5][13]   = reg_io.sr_enable_out;

        // status register mapping
        reg_io.status_we                 = reg_adapter_io.write_en[6]; //write enable map

        reg_io.stop_in                   = reg_adapter_io.data_in [0];
        reg_io.din_full_in               = reg_adapter_io.data_in [1];
        reg_io.din_empty_in              = reg_adapter_io.data_in [2];
        reg_io.dout_full_in              = reg_adapter_io.data_in [3];
        reg_io.slave_ACK_in              = reg_adapter_io.data_in [4];
        reg_io.slave_NACK_in             = reg_adapter_io.data_in [5];

        reg_adapter_io.data_out[6][0]    = reg_io.stop_out;     //output map
        reg_adapter_io.data_out[6][1]    = reg_io.din_full_out;
        reg_adapter_io.data_out[6][2]    = reg_io.din_empty_out;
        reg_adapter_io.data_out[6][3]    = reg_io.dout_full_out;
        reg_adapter_io.data_out[6][4]    = reg_io.slave_ACK_out;
        reg_adapter_io.data_out[6][5]    = reg_io.slave_NACK_out;
        reg_adapter_io.data_out[6][6]    = reg_io.bus_available_out;
        reg_adapter_io.data_out[6][7]    = reg_io.arb_loss_out;
        reg_adapter_io.data_out[7][31:0] = reg_io.bytes_read_out;
        reg_adapter_io.data_out[8][31:0] = reg_io.bytes_written_out;

    end


endmodule

