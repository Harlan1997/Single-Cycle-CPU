-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xxinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xxinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Single_Cycle_CPU.srcs/sources_1/ip/clk23Mhz/clk23Mhz_clk_wiz.v" \
  "../../../../Single_Cycle_CPU.srcs/sources_1/ip/clk23Mhz/clk23Mhz.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

