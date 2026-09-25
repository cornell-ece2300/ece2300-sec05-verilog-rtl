//========================================================================
// ece2300-test
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024
//
// ECE 2300 unit testing library for lab assignments.
//

`ifndef ECE2300_TEST_V
`define ECE2300_TEST_V

//------------------------------------------------------------------------
// Colors
//------------------------------------------------------------------------

`define ECE2300_RED    "\033[31m"
`define ECE2300_GREEN  "\033[32m"
`define ECE2300_YELLOW "\033[33m"
`define ECE2300_RESET  "\033[0m"

//========================================================================
// TestUtils
//========================================================================

module TestUtils();

  logic clk;
  logic rst;

  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  // status tracking

  logic failed = 0;
  logic passed = 0;
  int   num_checks = 0;
  int   num_test_cases_passed = 0;
  int   num_test_cases_failed = 0;

  // This variable holds the +test-case command line argument indicating
  // which test cases to run.

  string vcd_filename;
  int n = 0;
  initial begin

    if ( !$value$plusargs( "test-case=%d", n ) )
      n = 0;

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end

  end

  // Always call $urandom with this seed variable to ensure that random
  // test cases are both isolated and reproducible.

  // verilator lint_off UNUSEDSIGNAL
  int seed = 32'hdeadbeef;
  // verilator lint_on UNUSEDSIGNAL

  // Cycle counter with timeout check

  int cycles;

  always @( posedge clk ) begin

    if ( rst )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 9999 ) begin
      if ( n != 0 )
        $display( "" );
      $display( `ECE2300_RED, "FAILED", `ECE2300_RESET,
                " (timeout after %0d cycles)\n", cycles );

      $finish;
    end

  end

  //----------------------------------------------------------------------
  // test_bench_begin
  //----------------------------------------------------------------------

  task test_bench_begin();
    $display("");
    num_test_cases_passed = 0;
    num_test_cases_failed = 0;
  endtask

  //----------------------------------------------------------------------
  // test_bench_end
  //----------------------------------------------------------------------

  task test_bench_end();
    if ( n <= 0 ) begin
      if ( n == 0 )
        $write("\n");
      $display("num_test_cases_passed = %2d", num_test_cases_passed );
      $display("num_test_cases_failed = %2d", num_test_cases_failed );
      $write("\n");
    end
    else begin
      $write("\n");
      if ( (failed == 0) && (passed > 0) )
        $write( `ECE2300_GREEN, "passed", `ECE2300_RESET );
      else
        $write( `ECE2300_RED, "FAILED", `ECE2300_RESET );

      $write( " (%3d checks)\n", num_checks );

      $write("\n");
    end
    $finish;
  endtask

  //----------------------------------------------------------------------
  // test_case_begin
  //----------------------------------------------------------------------

  task test_case_begin( string taskname );
    $write("%-40s ",taskname);
    if ( n != 0 )
      $write("\n");

    seed = 32'hdeadbeef;
    num_checks = 0;
    failed = 0;
    passed = 0;

    rst = 1;
    #30;
    rst = 0;
  endtask

  //----------------------------------------------------------------------
  // test_case_end
  //----------------------------------------------------------------------

  task test_case_end();

    if ( (failed == 0) && (passed > 0) )
      num_test_cases_passed += 1;
    else
      num_test_cases_failed += 1;

    if ( n == 0 ) begin
      if ( (failed == 0) && (passed > 0) )
        $write( `ECE2300_GREEN, "passed", `ECE2300_RESET );
      else
        $write( `ECE2300_RED, "FAILED", `ECE2300_RESET );

      $write( " (%3d checks)\n", num_checks );
    end

    if ( n < 0 )
      $display("");

  endtask

endmodule

//========================================================================
// TestUtilsClkRst
//========================================================================

module TestUtilsClkRst
(
  output logic clk,
  output logic rst
);

  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  // verilator lint_off UNUSEDPARAM
  localparam outputs_undefined = 1;
  // verilator lint_on UNUSEDPARAM

  // status tracking

  logic failed = 0;
  logic passed = 0;
  int   num_checks = 0;
  int   num_test_cases_passed = 0;
  int   num_test_cases_failed = 0;

  // This variable holds the +test-case command line argument indicating
  // which test cases to run.

  string vcd_filename;
  int n = 0;
  initial begin

    if ( !$value$plusargs( "test-case=%d", n ) )
      n = 0;

    if ( $value$plusargs( "dump-vcd=%s", vcd_filename ) ) begin
      $dumpfile(vcd_filename);
      $dumpvars();
    end

  end

  // Always call $urandom with this seed variable to ensure that random
  // test cases are both isolated and reproducible.

  // verilator lint_off UNUSEDSIGNAL
  int seed = 32'hdeadbeef;
  // verilator lint_on UNUSEDSIGNAL

  // Cycle counter with timeout check

  int cycles;

  always @( posedge clk ) begin

    if ( rst )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 9999 ) begin
      if ( n != 0 )
        $display( "" );
      $display( `ECE2300_RED, "FAILED", `ECE2300_RESET,
                " (timeout after %0d cycles)\n", cycles );

      $finish;
    end

  end

  //----------------------------------------------------------------------
  // test_bench_begin
  //----------------------------------------------------------------------
  // We add this 1 tau delay at the beginning of the test bench to offset
  // all checks by 1 tau delay.

  task test_bench_begin();
    $display("");
    num_test_cases_passed = 0;
    num_test_cases_failed = 0;
    #1;
  endtask

  //----------------------------------------------------------------------
  // test_bench_end
  //----------------------------------------------------------------------

  task test_bench_end();
    if ( n <= 0 ) begin
      if ( n == 0 )
        $write("\n");
      $display("num_test_cases_passed = %2d", num_test_cases_passed );
      $display("num_test_cases_failed = %2d", num_test_cases_failed );
      $write("\n");
    end
    else begin
      $write("\n");
      if ( (failed == 0) && (passed > 0) )
        $write( `ECE2300_GREEN, "passed", `ECE2300_RESET );
      else
        $write( `ECE2300_RED, "FAILED", `ECE2300_RESET );

      $write( " (%3d checks)\n", num_checks );

      $write("\n");
    end
    $finish;
  endtask

  //----------------------------------------------------------------------
  // test_case_begin
  //----------------------------------------------------------------------

  task test_case_begin( string taskname );
    $write("%-40s ",taskname);
    if ( n != 0 )
      $write("\n");

    seed = 32'hdeadbeef;
    num_checks = 0;
    failed = 0;
    passed = 0;

    rst = 1;
    #30;
    rst = 0;
  endtask

  //----------------------------------------------------------------------
  // test_case_end
  //----------------------------------------------------------------------

  task test_case_end();

    if ( (failed == 0) && (passed > 0) )
      num_test_cases_passed += 1;
    else
      num_test_cases_failed += 1;

    if ( n == 0 ) begin
      if ( (failed == 0) && (passed > 0) )
        $write( `ECE2300_GREEN, "passed", `ECE2300_RESET );
      else
        $write( `ECE2300_RED, "FAILED", `ECE2300_RESET );

      $write( " (%3d checks)\n", num_checks );
    end

    if ( n < 0 )
      $display("");

  endtask

endmodule

//------------------------------------------------------------------------
// ECE2300_CHECK_EQ
//------------------------------------------------------------------------
// Compare two expressions which can be signals or constants. We use the
// !== operator so that Xs must also match exactly.

`define ECE2300_CHECK_EQ( __dut, __ref )                                \
  if ( __ref !== __dut ) begin                                          \
    if ( t.n != 0 ) begin                                               \
      $display( "" );                                                   \
      $display( "ERROR: Value on output port %s is incorrect on cycle %0d", \
                "__dut", t.cycles );                                    \
      $display( " - actual value   : %b", __dut );                      \
      $display( " - expected value : %b", __ref );                      \
    end                                                                 \
    t.failed = 1;                                                       \
  end                                                                   \
  else begin                                                            \
    t.passed = 1;                                                       \
  end                                                                   \
  if (1)

//------------------------------------------------------------------------
// ECE2300_CHECK_EQ_HEX
//------------------------------------------------------------------------
// Compare two expressions which can be signals or constants. We use the
// !== operator so that Xs must also match exactly. Display using hex.

`define ECE2300_CHECK_EQ_HEX( __dut, __ref )                            \
  if ( __ref !== __dut ) begin                                          \
    if ( t.n != 0 ) begin                                               \
      $display( "" );                                                   \
      $display( "ERROR: Value on output port %s is incorrect on cycle %0d", \
                "__dut", t.cycles );                                    \
      $display( " - actual value   : %h", __dut );                      \
      $display( " - expected value : %h", __ref );                      \
    end                                                                 \
    t.failed = 1;                                                       \
  end                                                                   \
  else begin                                                            \
    t.passed = 1;                                                       \
  end                                                                   \
  if (1)

//------------------------------------------------------------------------
// ECE2300_CHECK_EQ_STR
//------------------------------------------------------------------------
// Compare two expressions which can be signals or constants. We use the
// !== operator so that Xs must also match exactly. Display using string.

`define ECE2300_CHECK_EQ_STR( __dut, __ref )                            \
  if ( __ref !== __dut ) begin                                          \
    if ( t.n != 0 ) begin                                               \
      $display( "" );                                                   \
      $display( "ERROR: Value on output port %s is incorrect on cycle %0d", \
                "__dut", t.cycles );                                    \
      $display( " - actual value   : %-s", __dut );                     \
      $display( " - expected value : %-s", __ref );                     \
    end                                                                 \
    t.failed = 1;                                                       \
  end                                                                   \
  else begin                                                            \
    t.passed = 1;                                                       \
  end                                                                   \
  if (1)

`endif /* ECE2300_TEST_V */

