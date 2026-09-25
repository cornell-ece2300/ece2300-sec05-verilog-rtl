//========================================================================
// SubtractorRippleCarry_4b_GL
//========================================================================

`ifndef SUBTRACTOR_RIPPLE_CARRY_4B_GL_V
`define SUBTRACTOR_RIPPLE_CARRY_4B_GL_V

`include "ece2300/ece2300-misc.v"
`include "absdiff/FullSubtractor_GL.v"

module SubtractorRippleCarry_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) output wire [3:0] diff
);

  // Declare a wire for every intermediate borrow
  wire [3:0] borrow;

  FullSubtractor_GL full_subtractor_0
  (
    .in0  (in0[0]),
    .in1  (in1[0]),
    .bin  (1'b0),
    .bout (borrow[0]),
    .diff (diff[0])
  );

  FullSubtractor_GL full_subtractor_1
  (
    .in0  (in0[1]),
    .in1  (in1[1]),
    .bin  (borrow[0]),
    .bout (borrow[1]),
    .diff (diff[1])
  );

  FullSubtractor_GL full_subtractor_2
  (
    .in0  (in0[2]),
    .in1  (in1[2]),
    .bin  (borrow[1]),
    .bout (borrow[2]),
    .diff (diff[2])
    );

  FullSubtractor_GL full_subtractor_3
  (
    .in0  (in0[3]),
    .in1  (in1[3]),
    .bin  (borrow[2]),
    .bout (borrow[3]),
    .diff (diff[3])
  );

  `ECE2300_UNUSED( borrow[3] );

endmodule

`endif /* SUBTRACTOR_RIPPLE_CARRY_4B_GL_V */

