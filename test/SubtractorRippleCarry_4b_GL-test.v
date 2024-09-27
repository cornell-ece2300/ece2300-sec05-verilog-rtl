//========================================================================
// SubtractorRippleCarry_4b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "SubtractorRippleCarry_4b_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk;
  logic reset;
  // verilator lint_on UNUSED

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic [3:0] dut_in0;
  logic [3:0] dut_in1;
  logic       dut_bin;
  logic       dut_bout;
  logic [3:0] dut_diff;

  SubtractorRippleCarry_4b_GL dut
  (
    .in0  (dut_in0),
    .in1  (dut_in1),
    .bin  (dut_bin),
    .bout (dut_bout),
    .diff  (dut_diff)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [3:0] in0,
    input logic [3:0] in1,
    input logic       bin,
    input logic       bout,
    input logic [3:0] diff
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_bin = bin;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b - %b - %b (%2d - %2d - %b) > %b %b (%2d)", t.cycles,
                dut_in0, dut_in1, dut_bin, dut_in0, dut_in1, dut_bin,
                dut_bout, dut_diff, dut_diff );
      end

      `ECE2300_CHECK_EQ( dut_bout, bout );
      `ECE2300_CHECK_EQ( dut_diff, diff );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0 in1 bin bo  diff
    check( 0,  0,  0,  0,  0 );
    check( 1,  0,  0,  0,  1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_small
  //----------------------------------------------------------------------

  task test_case_2_directed_small();
    t.test_case_begin( "test_case_2_directed_small" );

    //     in0 in1 bin bo  diff
    check( 1,  0,  0,  0,  1 );
    check( 1,  1,  0,  0,  0 );

    check( 2,  0,  0,  0,  2 );
    check( 2,  1,  0,  0,  1 );
    check( 2,  2,  0,  0,  0 );

    check( 3,  0,  0,  0,  3 );
    check( 3,  1,  0,  0,  2 );
    check( 3,  2,  0,  0,  1 );
    check( 3,  3,  0,  0,  0 );

    check( 4,  0,  0,  0,  4 );
    check( 4,  1,  0,  0,  3 );
    check( 4,  2,  0,  0,  2 );
    check( 4,  3,  0,  0,  1 );

    check( 5,  0,  0,  0,  5 );
    check( 5,  1,  0,  0,  4 );
    check( 5,  2,  0,  0,  3 );
    check( 5,  3,  0,  0,  2 );
    check( 5,  4,  0,  0,  1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_large
  //----------------------------------------------------------------------

  task test_case_3_directed_large();
    t.test_case_begin( "test_case_3_directed_large" );

    //     in0 in1 bin bo  diff
    check( 15, 15, 0,  0,   0 );
    check( 15, 14, 0,  0,   1 );
    check( 15, 13, 0,  0,   2 );
    check( 15, 12, 0,  0,   3 );
    check( 15,  3, 0,  0,  12 );
    check( 15,  2, 0,  0,  13 );
    check( 15,  1, 0,  0,  14 );
    check( 15,  0, 0,  0,  15 );

  endtask

  //----------------------------------------------------------------------
  // test_case_4_directed_small_bin
  //----------------------------------------------------------------------

  task test_case_4_directed_small_bin();
    t.test_case_begin( "test_case_4_directed_bin" );

    //     in0 in1 bin bo  diff
    check( 1,  0,  1,  0,  0 );

    check( 2,  0,  1,  0,  1 );
    check( 2,  1,  1,  0,  0 );

    check( 3,  0,  1,  0,  2 );
    check( 3,  1,  1,  0,  1 );
    check( 3,  2,  1,  0,  0 );

    check( 3,  0,  1,  0,  2 );
    check( 3,  1,  1,  0,  1 );
    check( 3,  2,  1,  0,  0 );

    check( 4,  0,  1,  0,  3 );
    check( 4,  1,  1,  0,  2 );
    check( 4,  2,  1,  0,  1 );

    check( 5,  0,  1,  0,  4 );
    check( 5,  1,  1,  0,  3 );
    check( 5,  2,  1,  0,  2 );
    check( 5,  3,  1,  0,  1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_5_directed_large_bin
  //----------------------------------------------------------------------

  task test_case_5_directed_large_bin();
    t.test_case_begin( "test_case_5_directed_large_bin" );

    //     in0 in1 bin bo  diff
    check( 15, 14, 1,  0,   0 );
    check( 15, 13, 1,  0,   1 );
    check( 15, 12, 1,  0,   2 );
    check( 15,  3, 1,  0,  11 );
    check( 15,  2, 1,  0,  12 );
    check( 15,  1, 1,  0,  13 );
    check( 15,  0, 1,  0,  14 );

  endtask

  //----------------------------------------------------------------------
  // test_case_6_directed_small_bout
  //----------------------------------------------------------------------

  task test_case_6_directed_small_bout();
    t.test_case_begin( "test_case_6_directed_bout" );

    //     in0 in1 bin bo  diff
    check( 1,  2,  0,  1,  4'b1111 );
    check( 1,  3,  0,  1,  4'b1110 );
    check( 1,  4,  0,  1,  4'b1101 );

    check( 2,  3,  0,  1,  4'b1111 );
    check( 2,  4,  0,  1,  4'b1110 );
    check( 2,  5,  0,  1,  4'b1101 );

    check( 3,  4,  0,  1,  4'b1111 );
    check( 3,  5,  0,  1,  4'b1110 );
    check( 3,  6,  0,  1,  4'b1101 );

    check( 4,  5,  0,  1,  4'b1111 );
    check( 4,  6,  0,  1,  4'b1110 );
    check( 4,  7,  0,  1,  4'b1101 );

    check( 5,  6,  0,  1,  4'b1111 );
    check( 5,  7,  0,  1,  4'b1110 );
    check( 5,  8,  0,  1,  4'b1101 );

  endtask

  //----------------------------------------------------------------------
  // test_case_7_directed_large_bout
  //----------------------------------------------------------------------

  task test_case_7_directed_large_bout();
    t.test_case_begin( "test_case_7_directed_large_bout" );

    //     in0 in1 bin bo  diff
    check( 14, 15, 0,  1,  4'b1111 );

    check( 13, 15, 0,  1,  4'b1110 );
    check( 13, 14, 0,  1,  4'b1111 );

    check( 12, 15, 0,  1,  4'b1101 );
    check( 12, 14, 0,  1,  4'b1110 );
    check( 12, 13, 0,  1,  4'b1111 );

    check( 11, 15, 0,  1,  4'b1100 );
    check( 11, 14, 0,  1,  4'b1101 );
    check( 11, 13, 0,  1,  4'b1110 );
    check( 11, 12, 0,  1,  4'b1111 );

  endtask

  //----------------------------------------------------------------------
  // test_case_8_random
  //----------------------------------------------------------------------

  logic [3:0] rand_in0;
  logic [3:0] rand_in1;
  logic [3:0] rand_diff;
  logic       rand_bin;
  logic       rand_bout;

  task test_case_8_random();
    t.test_case_begin( "test_case_8_random" );

    for ( int i = 0; i < 50; i = i+1 )
    begin

      // Generate random values for in0, in1, bin

      rand_in0 = 4'($urandom(t.seed));
      rand_in1 = 4'($urandom(t.seed));
      rand_bin = 1'($urandom(t.seed));

      // Determine correct answer, we need to zero-extend rand_bin

      {rand_bout, rand_diff} = rand_in0 - rand_in1 - {3'b0, rand_bin};

      // Check DUT output matches correct answer

      check( rand_in0, rand_in1, rand_bin, rand_bout, rand_diff );

    end

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_small();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_large();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_small_bin();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_directed_large_bin();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_directed_small_bout();
    if ((t.n <= 0) || (t.n == 7)) test_case_7_directed_large_bout();
    if ((t.n <= 0) || (t.n == 8)) test_case_8_random();

    t.test_bench_end();
  end

endmodule
