//========================================================================
// SubtractorRippleCarry_4b_GL-test
//========================================================================

`include "ece2300/ece2300-test.v"
`include "absdiff/SubtractorRippleCarry_4b_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  TestUtils t();

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic [3:0] in0;
  logic [3:0] in1;
  logic       bin;
  logic       bout;
  logic [3:0] diff;

  SubtractorRippleCarry_4b_GL dut
  (
    .in0  (in0),
    .in1  (in1),
    .bin  (bin),
    .bout (bout),
    .diff (diff)
  );

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "absdiff/test/Subtractor_4b-test-cases.v"

endmodule
