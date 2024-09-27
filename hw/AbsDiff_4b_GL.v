//========================================================================
// AbsDiff_4b_GL
//========================================================================

`ifndef ABS_DIFF_4B_GL_V
`define ABS_DIFF_4B_GL_V

`include "GTComparator_4b_GL.v"
`include "Mux2_4b_GL.v"
`include "SubtractorRippleCarry_4b_GL.v"

module AbsDiff_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) output wire [3:0] diff
);

  wire cmp_gt;

  GTComparator_4b_GL cmp
  (
    .in0 (in0),
    .in1 (in1),
    .gt  (cmp_gt)
  );

  wire [3:0] mux0_out;

  Mux2_4b_GL mux0
  (
    .in0 (in1),
    .in1 (in0),
    .sel (cmp_gt),
    .out (mux0_out)
  );

  wire [3:0] mux1_out;

  Mux2_4b_GL mux1
  (
    .in0 (in0),
    .in1 (in1),
    .sel (cmp_gt),
    .out (mux1_out)
  );

  wire unused_bout;

  SubtractorRippleCarry_4b_GL sub
  (
    .in0  (mux0_out),
    .in1  (mux1_out),
    .bin  (1'b0),
    .bout (unused_bout),
    .diff (diff)
  );

endmodule

`endif /* ABS_DIFF_4B_GL_V */

