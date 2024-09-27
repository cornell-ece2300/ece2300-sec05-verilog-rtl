//========================================================================
// GTComparator_4b_GL
//========================================================================

`ifndef GT_COMPARATOR_4B_GL_V
`define GT_COMPARATOR_4B_GL_V

`include "GTComparator_1b_GL.v"

module GTComparator_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) output wire       gt
);

  // Declare a wire for every intermediate done bit and gt bit
  wire [2:0] done;
  wire [3:0] gt_tmp;

  GTComparator_1b_GL gt_comparator_3
  (
    .in0  (in0[3]),
    .in1  (in1[3]),
    .din  (1'b0),
    .dout (done[2]),
    .gt   (gt_tmp[3])
  );

  GTComparator_1b_GL gt_comparator_2
  (
    .in0  (in0[2]),
    .in1  (in1[2]),
    .din  (done[2]),
    .dout (done[1]),
    .gt   (gt_tmp[2])
  );

  GTComparator_1b_GL gt_comparator_1
  (
    .in0  (in0[1]),
    .in1  (in1[1]),
    .din  (done[1]),
    .dout (done[0]),
    .gt   (gt_tmp[1])
  );

  wire unused_dout;

  GTComparator_1b_GL gt_comparator_0
  (
    .in0  (in0[0]),
    .in1  (in1[0]),
    .din  (done[0]),
    .dout (unused_dout),
    .gt   (gt_tmp[0])
  );


  // Final OR gate

  or( gt, gt_tmp[0], gt_tmp[1], gt_tmp[2], gt_tmp[3] );

endmodule

`endif /* GT_COMPARATOR_4B_GL_V */

