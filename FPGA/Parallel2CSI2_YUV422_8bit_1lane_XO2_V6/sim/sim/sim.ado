setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/sim/sim/sim.adf"]} { 
	design create sim "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/sim"
  set newDesign 1
}
design open "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/sim/sim"
cd "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/sim"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/parallel2byte_8s_1s_43.vo"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/packetheader_1s.vo"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/crc16_1lane.vo"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/colorbar_gen.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/IO_Controller_TX.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/oDDRx4.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/DPHY_TX_INST.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/LP_HS_dly_ctrl.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/BYTE_PACKETIZER.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/IPExpress/pll_pix2byte_YUV422_8bit_1lane.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/top.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/Parallel2CSI2_tb_1lane.v"
addfile "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/compiler_directives.v"
vlib "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/sim/sim/work"
set worklib work
adel -all
vlog -dbg "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/parallel2byte_8s_1s_43.vo"
vlog -dbg "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/packetheader_1s.vo"
vlog -dbg "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/crc16_1lane.vo"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/colorbar_gen.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/IO_Controller_TX.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/oDDRx4.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/DPHY_TX_INST.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/LP_HS_dly_ctrl.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/BYTE_PACKETIZER.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/IPExpress/pll_pix2byte_YUV422_8bit_1lane.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/top.v"
vlog -dbg "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/Parallel2CSI2_tb_1lane.v"
vlog -dbg -work work "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/compiler_directives.v"
module Parallel2CSI2_tb
vsim  +access +r Parallel2CSI2_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
