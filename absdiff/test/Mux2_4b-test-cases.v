//========================================================================
// Mux2_4b-test-cases
//========================================================================
// This file is meant to be included in a test bench.

//------------------------------------------------------------------------
// check
//------------------------------------------------------------------------
// We wait 1 tau, set the inputs, wait 8 tau, check the outputs, wait 1
// tau. Each check will take a total of 10 tau.

task check
(
  input logic [3:0] in0_,
  input logic [3:0] in1_,
  input logic       sel_,
  input logic [3:0] out_
);
  if ( !t.failed ) begin
    t.num_checks += 1;

    #1;

    in0 = in0_;
    in1 = in1_;
    sel = sel_;

    #8;

    if ( t.n != 0 )
      $display( "%3d: %b %b %b > %b", t.cycles, in0, in1, sel, out );

    `ECE2300_CHECK_EQ( out, out_ );

    #1;

  end
endtask

//------------------------------------------------------------------------
// test_case_1_basic
//------------------------------------------------------------------------

task test_case_1_basic();
  t.test_case_begin( "test_case_1_basic" );

  //     in0      in1      sel   out
  check( 4'b0000, 4'b0000, 1'b0, 4'b0000 );
  check( 4'b0000, 4'b0000, 1'b1, 4'b0000 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_2_directed
//------------------------------------------------------------------------

task test_case_2_directed();
  t.test_case_begin( "test_case_2_directed" );

  //     in0      in1      sel   out
  check( 4'b0000, 4'b0000, 1'b0, 4'b0000 );
  check( 4'b1111, 4'b0000, 1'b0, 4'b1111 );
  check( 4'b0101, 4'b1010, 1'b0, 4'b0101 );
  check( 4'b1010, 4'b0101, 1'b0, 4'b1010 );

  check( 4'b0000, 4'b0000, 1'b1, 4'b0000 );
  check( 4'b1111, 4'b0000, 1'b1, 4'b0000 );
  check( 4'b0101, 4'b1010, 1'b1, 4'b1010 );
  check( 4'b1010, 4'b0101, 1'b1, 4'b0101 );

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_3_random
//------------------------------------------------------------------------

logic [3:0] rand_in0;
logic [3:0] rand_in1;
logic       rand_sel;
logic [3:0] rand_out;

task test_case_3_random();
  t.test_case_begin( "test_case_3_random" );

  for ( int i = 0; i < 50; i = i+1 ) begin

    // Generate random values for in0, in1, sel

    rand_in0 = 4'($urandom(t.seed));
    rand_in1 = 4'($urandom(t.seed));
    rand_sel = 1'($urandom(t.seed));

    // Determine correct answer

    if ( rand_sel == 0 )
      rand_out = rand_in0;
    else
      rand_out = rand_in1;

    // Check DUT output matches correct answer

    check( rand_in0, rand_in1, rand_sel, rand_out );

  end

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// test_case_4_xprop
//------------------------------------------------------------------------

task test_case_4_xprop();
  t.test_case_begin( "test_case_4_xprop" );

  //     in0 in1 sel out
  check( 'x, 'x, 'x, 'x );

  `ifdef USE_RTL_XPROP_TESTS
  check( '0, '0, 'x, 'x );
  check( '0, '1, 'x, 'x );
  check( '1, '0, 'x, 'x );
  check( '1, '1, 'x, 'x );

  check( '0, 'x, '0, '0 );
  check( '0, 'x, '1, 'x );
  check( '1, 'x, '0, '1 );
  check( '1, 'x, '1, 'x );

  check( 'x, '0, '0, 'x );
  check( 'x, '0, '1, '0 );
  check( 'x, '1, '0, 'x );
  check( 'x, '1, '1, '1 );
  `endif

  t.test_case_end();
endtask

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

initial begin
  t.test_bench_begin();

  if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
  if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
  if ((t.n <= 0) || (t.n == 3)) test_case_3_random();
  if ((t.n <= 0) || (t.n == 4)) test_case_4_xprop();

  t.test_bench_end();
end

