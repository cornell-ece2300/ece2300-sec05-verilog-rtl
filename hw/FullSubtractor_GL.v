//========================================================================
// FullSubtractor_GL
//========================================================================

`ifndef FULL_SUBTRACTOR_GL_V
`define FULL_SUBTRACTOR_GL_V

module FullSubtractor_GL
(
  (* keep=1 *) input  wire in0,
  (* keep=1 *) input  wire in1,
  (* keep=1 *) input  wire bin,
  (* keep=1 *) output wire bout,
  (* keep=1 *) output wire diff
);

  // NOT gates to complement in0

  wire in0_b;

  not( in0_b, in0 );

  // XOR gate for diff output

  xor( diff, in0, in1, bin );

  // Simplified sum-of-products for bout output

  wire p0, p1, p2;

  and( p0, in0_b, in1 );
  and( p1, in0_b, bin );
  and( p2, in1,   bin );
  or ( bout, p0, p1, p2 );

endmodule

`endif /* FULL_SUBTRACTOR_GL_V */

