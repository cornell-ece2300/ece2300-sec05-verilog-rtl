//========================================================================
// GTComparator_4b_RTL
//========================================================================

`ifndef GT_COMPARATOR_4B_V
`define GT_COMPARATOR_4B_V

`include "ece2300/ece2300-misc.v"

module GTComparator_4b_RTL
(
  (* keep=1 *) input  logic [3:0] in0,
  (* keep=1 *) input  logic [3:0] in1,
  (* keep=1 *) output logic       gt
);

  //''' ACTIVITY '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement 4b greater-than comparator using RTL
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  `ECE2300_UNUSED( in0 );
  `ECE2300_UNUSED( in1 );
  `ECE2300_FLOATING( gt );

endmodule

`endif /* GT_COMPARATOR_4B_RTL_V */

