//========================================================================
// SubtractorRippleCarry_4b_GL
//========================================================================

`ifndef SUBTRACTOR_RIPPLE_CARRY_4B_GL_V
`define SUBTRACTOR_RIPPLE_CARRY_4B_GL_V

`include "FullSubtractor_GL.v"

module SubtractorRippleCarry_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) input  wire       bin,
  (* keep=1 *) output wire       bout,
  (* keep=1 *) output wire [3:0] diff
);

  // Declare a wire for every intermediate borrow
  wire [2:0] borrow;

  FullSubtractor_GL full_subtractor_0
  (
    .in0  (in0[0]),
    .in1  (in1[0]),
    .bin  (bin),
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
    .bout (bout),
    .diff (diff[3])
  );

endmodule

`endif /* SUBTRACTOR_RIPPLE_CARRY_4B_GL_V */

