//========================================================================
// Mux2_4b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Mux2_4b_RTL.v"

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
  logic       dut_sel;
  logic [3:0] dut_out;

  Mux2_4b_RTL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .sel (dut_sel),
    .out (dut_out)
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
    input logic       sel,
    input logic [3:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b > %b", t.cycles,
                  dut_in0, dut_in1, dut_sel, dut_out );
      end

      `ECE2300_CHECK_EQ( dut_out, out );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0      in1      sel   out
    check( 4'b0000, 4'b0000, 1'b0, 4'b0000 );
    check( 4'b0000, 4'b0000, 1'b1, 4'b0000 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed
  //----------------------------------------------------------------------

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

  endtask

  //----------------------------------------------------------------------
  // test_case_3_random
  //----------------------------------------------------------------------

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

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_random();

    t.test_bench_end();
  end

endmodule
