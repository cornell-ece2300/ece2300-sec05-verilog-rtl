//========================================================================
// GTComparator_4b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "GTComparator_4b_GL.v"

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
  logic       dut_gt;

  GTComparator_4b_GL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .gt  (dut_gt)
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
    input logic       gt
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b (%2d - %2d) > %b", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1, dut_gt );
      end

      `ECE2300_CHECK_EQ( dut_gt, gt );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0 in1 gt
    check( 0,  0,  0 );
    check( 1,  0,  1 );
    check( 0,  1,  0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_small
  //----------------------------------------------------------------------

  task test_case_2_directed_small();
    t.test_case_begin( "test_case_2_directed_small" );

    //     in0 in1 gt
    check( 2,  0,  1 );
    check( 2,  1,  1 );
    check( 0,  2,  0 );
    check( 1,  2,  0 );
    check( 2,  2,  0 );

    check( 3,  0,  1 );
    check( 3,  1,  1 );
    check( 3,  2,  1 );
    check( 0,  3,  0 );
    check( 1,  3,  0 );
    check( 2,  3,  0 );
    check( 3,  3,  0 );

    check( 4,  0,  1 );
    check( 4,  1,  1 );
    check( 4,  2,  1 );
    check( 4,  3,  1 );
    check( 0,  4,  0 );
    check( 1,  4,  0 );
    check( 2,  4,  0 );
    check( 3,  4,  0 );
    check( 4,  4,  0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_large
  //----------------------------------------------------------------------

  task test_case_3_directed_large();
    t.test_case_begin( "test_case_3_directed_large" );

    //     in0 in1 gt
    check( 15, 15, 0 );

    check( 15, 14, 1 );
    check( 15, 13, 1 );
    check( 15, 12, 1 );
    check( 15, 11, 1 );
    check( 15,  3, 1 );
    check( 15,  2, 1 );
    check( 15,  1, 1 );
    check( 15,  0, 1 );

    check( 14, 15, 0 );
    check( 13, 15, 0 );
    check( 12, 15, 0 );
    check( 11, 15, 0 );
    check(  3, 15, 0 );
    check(  2, 15, 0 );
    check(  1, 15, 0 );
    check(  0, 15, 0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_4_random
  //----------------------------------------------------------------------

  logic [3:0] rand_in0;
  logic [3:0] rand_in1;
  logic       rand_gt;

  task test_case_4_random();
    t.test_case_begin( "test_case_4_random" );

    for ( int i = 0; i < 50; i = i+1 )
    begin

      // Generate random values for in0, in1, cin

      rand_in0 = 4'($urandom(t.seed));
      rand_in1 = 4'($urandom(t.seed));

      // Determine correct answer, we need to zero-extend rand_bin

      rand_gt = rand_in0 > rand_in1;

      // Check DUT output matches correct answer

      check( rand_in0, rand_in1, rand_gt );

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
    if ((t.n <= 0) || (t.n == 4)) test_case_4_random();

    t.test_bench_end();
  end

endmodule
