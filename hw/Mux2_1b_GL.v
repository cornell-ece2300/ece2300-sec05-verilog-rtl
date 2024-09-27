//========================================================================
// Mux2_1b_GL
//========================================================================

`ifndef MUX2_1B_GL
`define MUX2_1B_GL

module Mux2_1b_GL
(
  (* keep=1 *) input  in0,
  (* keep=1 *) input  in1,
  (* keep=1 *) input  sel,
  (* keep=1 *) output out
);

  // NOT gates to complement sel

  wire sel_b;

  not( sel_b, sel );

  // Simplified sum-of-products for output

  wire p0, p1;

  and( p0,  in0, sel_b );
  and( p1,  in1, sel   );
  or ( out, p0, p1 );

endmodule

`endif /* MUX2_1B_GL */

