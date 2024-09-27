//========================================================================
// GTComparator_1b_GL
//========================================================================

`ifndef GT_COMPARATOR_GL_V
`define GT_COMPARATOR_GL_V

module GTComparator_1b_GL
(
  (* keep=1 *) input  wire in0,
  (* keep=1 *) input  wire in1,
  (* keep=1 *) input  wire din,
  (* keep=1 *) output wire dout,
  (* keep=1 *) output wire gt
);

  // NOT gates to complement in1 and din

  wire in1_b, din_b;

  not( in1_b, in1 );
  not( din_b, din );

  // Simplified logic for dout

  wire p0;
  xor( p0, in0, in1 );
  or ( dout, din, p0 );

  // Simplified logic for gt

  and( gt, din_b, in0, in1_b );

endmodule

`endif /* GT_COMPARATOR_GL_V */

