setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/sim/sim/sim.adf"]} { 
	design create sim "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/sim"
  set newDesign 1
}
design open "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/sim/sim"
cd "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/sim"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/parallel2byte_8s_1s_43.vo"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/packetheader_1s.vo"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/crc16_1lane.vo"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/colorbar_gen.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/IO_Controller_TX.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/oDDRx4.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/DPHY_TX_INST.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/LP_HS_dly_ctrl.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/BYTE_PACKETIZER.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/IPExpress/pll_pix2byte_YUV422_8bit_1lane.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/top.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/Parallel2CSI2_tb_1lane.v"
addfile "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/compiler_directives.v"
vlib "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/sim/sim/work"
set worklib work
adel -all
vlog -dbg "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/parallel2byte_8s_1s_43.vo"
vlog -dbg "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/packetheader_1s.vo"
vlog -dbg "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/crc16_1lane.vo"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/colorbar_gen.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/IO_Controller_TX.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/oDDRx4.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/DPHY_TX_INST.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/LP_HS_dly_ctrl.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/BYTE_PACKETIZER.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/IPExpress/pll_pix2byte_YUV422_8bit_1lane.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/top.v"
vlog -dbg "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/Parallel2CSI2_XO2/tb/Parallel2CSI2_tb_1lane.v"
vlog -dbg -work work "E:/mipi_check/Parallel2CSI2_YUV422_8bit_1lane_XO2_V5/rtl/compiler_directives.v"
module Parallel2CSI2_tb
vsim  +access +r Parallel2CSI2_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
