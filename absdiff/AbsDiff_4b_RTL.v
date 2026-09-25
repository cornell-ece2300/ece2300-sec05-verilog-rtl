//========================================================================
// AbsDiff_4b_RTL
//========================================================================

`ifndef ABS_DIFF_4B_RTL_V
`define ABS_DIFF_4B_RTL_V

`include "ece2300/ece2300-misc.v"
`include "absdiff/GTComparator_4b_RTL.v"
`include "absdiff/Mux2_4b_RTL.v"
`include "absdiff/Subtractor_4b_RTL.v"

module AbsDiff_4b_RTL
(
  (* keep=1 *) input  logic [3:0] in0,
  (* keep=1 *) input  logic [3:0] in1,
  (* keep=1 *) output logic [3:0] diff
);

  //''' ACTIVITY '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement 4b absolute difference unit using RTL
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  `ECE2300_UNUSED( in0 );
  `ECE2300_UNUSED( in1 );
  `ECE2300_FLOATING( diff );

endmodule

`endif /* ABS_DIFF_4B_RTL_V */
