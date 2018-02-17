setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/sim/simulation/simulation.adf"]} { 
	design create simulation "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/sim"
  set newDesign 1
}
design open "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/sim/simulation"
cd "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/sim"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/parallel2byte_8s_2s_30.vo"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/packetheader_2s.vo"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/crc16_2lane.vo"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/colorbar_gen.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/IO_Controller_TX.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/oDDRx4.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/DPHY_TX_INST.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/LP_HS_dly_ctrl.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/BYTE_PACKETIZER.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/IPExpress/pll_pix2byte_YUV422_8bit_2lane.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/top.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/Parallel2CSI2_tb_2lane.v"
addfile "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/compiler_directives.v"
vlib "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/sim/simulation/work"
set worklib work
adel -all
vlog -dbg "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/parallel2byte_8s_2s_30.vo"
vlog -dbg "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/packetheader_2s.vo"
vlog -dbg "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/crc16_2lane.vo"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/colorbar_gen.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/IO_Controller_TX.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/oDDRx4.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/DPHY_TX_INST.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/LP_HS_dly_ctrl.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/BYTE_PACKETIZER.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/IPExpress/pll_pix2byte_YUV422_8bit_2lane.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/top.v"
vlog -dbg "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/Parallel2CSI2_tb_2lane.v"
vlog -dbg -work work "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/compiler_directives.v"
module Parallel2CSI2_tb
vsim +access +r Parallel2CSI2_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
