#=========================================================================
# absdiff
#=========================================================================

absdiff_srcs = \
  FullSubtractor_GL.v \
  SubtractorRippleCarry_4b_GL.v \
  GTComparator_1b_GL.v \
  GTComparator_4b_GL.v \
  Mux2_1b_GL.v \
  Mux2_4b_GL.v \
  AbsDiff_4b_GL.v \
  Subtractor_4b_RTL.v \
  GTComparator_4b_RTL.v \
  Mux2_4b_RTL.v \
  AbsDiff_4b_RTL.v \

absdiff_tests = \
  FullSubtractor_GL-test.v \
  SubtractorRippleCarry_4b_GL-test.v \
  GTComparator_1b_GL-test.v \
  GTComparator_4b_GL-test.v \
  Mux2_1b_GL-test.v \
  Mux2_4b_GL-test.v \
  AbsDiff_4b_GL-test.v \
  Subtractor_4b_RTL-test.v \
  GTComparator_4b_RTL-test.v \
  Mux2_4b_RTL-test.v \
  AbsDiff_4b_RTL-test.v \

absdiff_sims = \

$(eval $(call check_part,absdiff))
