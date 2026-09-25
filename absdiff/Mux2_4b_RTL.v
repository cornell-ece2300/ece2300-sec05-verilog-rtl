//========================================================================
// Mux2_4b_RTL
//========================================================================

`ifndef MUX2_4B_RTL
`define MUX2_4B_RTL

`include "ece2300/ece2300-misc.v"

module Mux2_4b_RTL
(
  (* keep=1 *) input  logic [3:0] in0,
  (* keep=1 *) input  logic [3:0] in1,
  (* keep=1 *) input  logic       sel,
  (* keep=1 *) output logic [3:0] out
);

  //''' ACTIVITY '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement 4b mux using RTL
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  `ECE2300_UNUSED( in0 );
  `ECE2300_UNUSED( in1 );
  `ECE2300_UNUSED( sel );
  `ECE2300_FLOATING( out );

endmodule

`endif /* MUX2_4B_RTL */

