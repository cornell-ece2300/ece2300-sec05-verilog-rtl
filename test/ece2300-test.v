//========================================================================
// ece2300-test
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024
//
// ECE 2300 standard library for lab assignments.
//

`ifndef ECE2300_STDLIB_V
`define ECE2300_STDLIB_V

//------------------------------------------------------------------------
// Colors
//------------------------------------------------------------------------

`define ECE2300_RED    "\033[31m"
`define ECE2300_GREEN  "\033[32m"
`define ECE2300_YELLOW "\033[33m"
`define ECE2300_RESET  "\033[0m"

//========================================================================
// ece2300_TestUtils
//========================================================================

module ece2300_TestUtils
(
  output logic clk,
  output logic reset
);

  // verilator lint_off BLKSEQ
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  // Error count

  logic failed = 0;

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

    if ( reset )
      cycles <= 0;
    else
      cycles <= cycles + 1;

    if ( cycles > 10000 ) begin
      $display( "\nERROR (cycles=%0d): timeout!", cycles );
      $finish;
    end

  end

  //----------------------------------------------------------------------
  // test_bench_begin
  //----------------------------------------------------------------------
  // We start with a #1 delay so that all tasks will essentially start at
  // #1 after the rising edge of the clock.
  // test_bench_begin

  task test_bench_begin( string filename );
    $write({"\n",filename});
    #1;
  endtask

  //----------------------------------------------------------------------
  // test_bench_end
  //----------------------------------------------------------------------

  task test_bench_end();
    $write("\n");
    if ( t.n == 0 )
      $write("\n");
    $finish;
  endtask

  //----------------------------------------------------------------------
  // test_case_begin
  //----------------------------------------------------------------------

  task test_case_begin( string taskname );
    $write({"\n",taskname," "});
    if ( t.n != 0 )
      $write("\n");

    seed = 32'hdeadbeef;
    failed = 0;

    reset = 1;
    #30;
    reset = 0;
  endtask

endmodule

//------------------------------------------------------------------------
// ECE2300_CHECK_EQ
//------------------------------------------------------------------------
// Compare two expressions which can be signals or constants. We use the
// XOR operator so that an X in __ref will match 0, 1, or X in __dut, but
// an X in __dut will only match an X in __ref.

`define ECE2300_CHECK_EQ( __dut, __ref )                                \
  if ( __ref !== ( __ref ^ __dut ^ __ref ) ) begin                      \
    if ( t.n != 0 )                                                     \
      $display( {"\n",`ECE2300_RED,"ERROR",`ECE2300_RESET," (cycle=%0d): %s != %s (%b != %b)"},\
                t.cycles, "__dut", "__ref", __dut, __ref );             \
    else                                                                \
      $write( {`ECE2300_RED,"FAILED",`ECE2300_RESET} );                 \
    t.failed = 1;                                                       \
  end                                                                   \
  else begin                                                            \
    if ( t.n == 0 )                                                     \
      $write( `ECE2300_GREEN, ".", `ECE2300_RESET );                    \
  end                                                                   \
  if (1)

`endif /* ECE2300_STDLIB */

