setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/sim/simulation/simulation.adf"]} { 
	design create simulation "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/sim"
  set newDesign 1
}
design open "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/sim/simulation"
cd "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/sim"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/parallel2byte_8s_4s_30.vo"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/packetheader_4s.vo"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/crc16_4lane.vo"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/colorbar_gen.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/IO_Controller_TX.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/oDDRx4.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/DPHY_TX_INST.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/LP_HS_dly_ctrl.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/BYTE_PACKETIZER.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/IPExpress/pll_pix2byte_YUV422_8bit_4lane.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/top.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/Parallel2CSI2_tb_4lane.v"
addfile "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/compiler_directives.v"
vlib "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/sim/simulation/work"
set worklib work
adel -all
vlog -dbg "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/parallel2byte_8s_4s_30.vo"
vlog -dbg "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/packetheader_4s.vo"
vlog -dbg "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/crc16_4lane.vo"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/colorbar_gen.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/IO_Controller_TX.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/oDDRx4.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/DPHY_TX_INST.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/LP_HS_dly_ctrl.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/BYTE_PACKETIZER.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/IPExpress/pll_pix2byte_YUV422_8bit_4lane.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/top.v"
vlog -dbg "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/Parallel2CSI2_tb_4lane.v"
vlog -dbg -work work "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/compiler_directives.v"
module Parallel2CSI2_tb
vsim  +access +r Parallel2CSI2_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
