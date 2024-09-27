#=========================================================================
# configure.ac for ECE 2300
#=========================================================================
# Author : Christopher Batten (Cornell)
# Date   : September 7, 2024

#-------------------------------------------------------------------------
# Project metadata
#-------------------------------------------------------------------------

m4_define( proj_name,         [ECE 2300 Section 5])
m4_define( proj_maintainer,   [Christopher Batten])
m4_define( proj_abbreviation, [sec05-verilog-rtl])
m4_define( proj_version,      [v0.1])

#-------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------

AC_INIT(proj_name,proj_version,proj_maintainer,proj_abbreviation)
AC_CONFIG_SRCDIR([scripts/mk-verilog-deps])

#-------------------------------------------------------------------------
# Basic checks
#-------------------------------------------------------------------------

# Checking for verilator

AC_CHECK_PROGS([VERILATOR],[verilator],[no])
AS_IF([test "${VERILATOR}" = "no"],
[
  AC_MSG_ERROR([Must have verilator installed!

Did you forget to source the setup script like this?

 % source setup-ece2300.sh

You will know you have sourced the setup script if you see ECE 2300 in
your prompt.
])
])

# Checking for iverilog

AC_CHECK_PROGS([IVERILOG],[iverilog],[no])
AS_IF([test "${IVERILOG}" = "no"],
[
  AC_MSG_ERROR([Must have iverilog installed!

Did you forget to source the setup script like this?

 % source setup-ece2300.sh

You will know you have sourced the setup script if you see ECE 2300 in
your prompt.
])
])

# Checking for working in a build directory

build_dir_basename=$(basename "${PWD}")
AS_CASE(["${build_dir_basename}"],
  [build*], [],
  [AC_MSG_ERROR([Must run configure in a build directory!])]
)

#-------------------------------------------------------------------------
# Output
#-------------------------------------------------------------------------

AC_CONFIG_FILES([Makefile])
AC_OUTPUT

