//========================================================================
// mux-rtl-sim +in0=0000 +in1=0000 +sel=0
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 27, 2024

`include "Mux2_4b_RTL.v"

//========================================================================
// Top
//========================================================================

module Top();

  //----------------------------------------------------------------------
  // Instantiate mux
  //----------------------------------------------------------------------

  logic [3:0] dut_in0;
  logic [3:0] dut_in1;
  logic       dut_sel;
  logic [3:0] dut_out;

  Mux2_4b_RTL mux
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .sel (dut_sel),
    .out (dut_out)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  initial begin

    // Process command line arguments

    if ( !$value$plusargs( "in0=%b", dut_in0 ) )
      dut_in0 = 4'b0000;

    if ( !$value$plusargs( "in1=%b", dut_in1 ) )
      dut_in1 = 4'b0000;

    if ( !$value$plusargs( "sel=%b", dut_sel ) )
      dut_sel = 1'b0;

    // Advance time

    #10;

    // Display output

    $display( "in0 = %b", dut_in0 );
    $display( "in1 = %b", dut_in1 );
    $display( "sel = %b", dut_sel );
    $display( "out = %b", dut_out );

    $finish;
  end

endmodule

