//========================================================================
// GTComparator_1b_GL-test
//========================================================================

`include "ece2300/ece2300-test.v"
`include "absdiff/GTComparator_1b_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  TestUtils t();

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic in0;
  logic in1;
  logic din;
  logic dout;
  logic gt;

  GTComparator_1b_GL dut
  (
    .in0  (in0),
    .in1  (in1),
    .din  (din),
    .dout (dout),
    .gt   (gt)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // We wait 1 tau, set the inputs, wait 8 tau, check the outputs, wait 1
  // tau. Each check will take a total of 10 tau.

  task check
  (
    input logic in0_,
    input logic in1_,
    input logic din_,
    input logic dout_,
    input logic gt_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      #1;

      in0 = in0_;
      in1 = in1_;
      din = din_;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %b %b %b > %b %b", t.cycles, in0, in1, din, dout, gt );

      `ECE2300_CHECK_EQ( dout, dout_ );
      `ECE2300_CHECK_EQ( gt, gt_ );

      #1;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0 in1 din do  gt
    check( 0,  0,  0,  0,  0 );
    check( 1,  0,  0,  1,  1 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );

    //     in0 in1 din do  gt
    check( 0,  0,  0,  0,  0  );
    check( 0,  0,  1,  1,  0  );
    check( 0,  1,  0,  1,  0  );
    check( 0,  1,  1,  1,  0  );

    check( 1,  0,  0,  1,  1  );
    check( 1,  0,  1,  1,  0  );
    check( 1,  1,  0,  0,  0  );
    check( 1,  1,  1,  1,  0  );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_xprop
  //----------------------------------------------------------------------

  task test_case_3_xprop();
    t.test_case_begin( "test_case_3_xprop" );

    //     in0 in1 din do  gt
    check( 'x, 'x, 'x, 'x, 'x  );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_exhaustive();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_xprop();

    t.test_bench_end();
  end

endmodule
