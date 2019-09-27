

interface i2c_native_register_interface;


    // clocks and resets
    logic          clk;
    logic          reset;


    // device register inputs
    logic  [7:0]   data_in_in;

    logic  [31:0]  read_length_in;
    logic  [31:0]  write_length_in;
    logic  [15:0]  clk_divider_in;
    logic          stop_ire_in;
    logic          din_full_ire_in;
    logic          din_empty_ire_in;
    logic          dout_full_ire_in;
    logic          ack_ire_in;
    logic          nack_ire_in;
    logic          bus_ire_in;
    logic          arb_ire_in;
    logic          fifo_enable_in;
    logic          packet_type_in;
    logic          start_in;
    logic          master_ACK_in;
    logic          master_NACK_in;
    logic          sr_enable_in;

    logic          stop_in;
    logic          din_full_in;
    logic          din_empty_in;
    logic          dout_full_in;
    logic          slave_ACK_in;
    logic          slave_NACK_in;

    // device register outputs
    logic  [7:0]   data_in_out;
    logic  [7:0]   data_out_out;

    logic  [31:0]  read_length_out;
    logic  [31:0]  write_length_out;
    logic  [15:0]  clk_divider_out;
    logic          stop_ire_out;
    logic          din_full_ire_out;
    logic          din_empty_ire_out;
    logic          dout_full_ire_out;
    logic          ack_ire_out;
    logic          nack_ire_out;
    logic          bus_ire_out;
    logic          arb_ire_out;
    logic          fifo_enable_out;
    logic          packet_type_out;
    logic          start_out;
    logic          master_ACK_out;
    logic          master_NACK_out;
    logic          sr_enable_out;

    logic          stop_out;
    logic          din_full_out;
    logic          din_empty_out;
    logic          dout_full_out;
    logic          slave_ACK_out;
    logic          slave_NACK_out;
    logic          bus_available_out;
    logic          arb_loss_out;
    logic  [31:0]  bytes_read_out;
    logic  [31:0]  bytes_written_out;

    // device register control signals
    logic          data_out_we;   // register write enables
    logic          read_length_we;
    logic          write_length_we;
    logic          clk_divider_we;
    logic          config_we;
    logic          status_we; //Note: bits 6 and 7 are read only

    // modport list (used to define signal direction for specific situations)
    modport in (
        input   clk,
        input   reset,
        input   data_in_in,
        input   read_length_in,
        input   write_length_in,
        input   clk_divider_in,
        input   stop_ire_in,
        input   din_full_ire_in,
        input   din_empty_ire_in,
        input   dout_full_ire_in,
        input   ack_ire_in,
        input   nack_ire_in,
        input   bus_ire_in,
        input   arb_ire_in,
        input   fifo_enable_in,
        input   packet_type_in,
        input   start_in,
        input   master_ACK_in,
        input   master_NACK_in,
        input   sr_enable_in,
        input   stop_in,
        input   din_full_in,
        input   din_empty_in,
        input   dout_full_in,
        input   slave_ACK_in,
        input   slave_NACK_in,
        
        output  data_in_out,
        output  data_out_out,
        output  read_length_out,
        output  write_length_out,
        output  clk_divider_out,
        output  stop_ire_out,
        output  din_full_ire_out,
        output  din_empty_ire_out,
        output  dout_full_ire_out,
        output  ack_ire_out,
        output  nack_ire_out,
        output  bus_ire_out,
        output  arb_ire_out,
        output  fifo_enable_out,
        output  packet_type_out,
        output  start_out,
        output  master_ACK_out,
        output  master_NACK_out,
        output  sr_enable_out,
        output  stop_out,
        output  din_full_out,
        output  din_empty_out,
        output  dout_full_out,
        output  slave_ACK_out,
        output  slave_NACK_out,
        output  bus_available_out,
        output  arb_loss_out,
        output  bytes_read_out,
        output  bytes_written_out
        
    );


    modport out (
        output   clk,
        output   reset,
        output   data_in_in,
        output   read_length_in,
        output   write_length_in,
        output   clk_divider_in,
        output   stop_ire_in,
        output   din_full_ire_in,
        output   din_empty_ire_in,
        output   dout_full_ire_in,
        output   ack_ire_in,
        output   nack_ire_in,
        output   bus_ire_in,
        output   arb_ire_in,
        output   fifo_enable_in,
        output   packet_type_in,
        output   start_in,
        output   master_ACK_in,
        output   master_NACK_in,
        output   sr_enable_in,
        output   stop_in,
        output   din_full_in,
        output   din_empty_in,
        output   dout_full_in,
        output   slave_ACK_in,
        output   slave_NACK_in,
        
        input  data_in_out,
        input  data_out_out,
        input  read_length_out,
        input  write_length_out,
        input  clk_divider_out,
        input  stop_ire_out,
        input  din_full_ire_out,
        input  din_empty_ire_out,
        input  dout_full_ire_out,
        input  ack_ire_out,
        input  nack_ire_out,
        input  bus_ire_out,
        input  arb_ire_out,
        input  fifo_enable_out,
        input  packet_type_out,
        input  start_out,
        input  master_ACK_out,
        input  master_NACK_out,
        input  sr_enable_out,
        input  stop_out,
        input  din_full_out,
        input  din_empty_out,
        input  dout_full_out,
        input  slave_ACK_out,
        input  slave_NACK_out,
        input  bus_available_out,
        input  arb_loss_out,
        input  bytes_read_out,
        input  bytes_written_out
    );


endinterface

