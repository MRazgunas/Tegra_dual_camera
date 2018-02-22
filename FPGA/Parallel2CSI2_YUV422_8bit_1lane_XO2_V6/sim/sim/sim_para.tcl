lappend auto_path "D:/FPGA/Lattice/diamond/3.8_x64/data/script"
package require simulation_generation
set ::bali::simulation::Para(PROJECT) {sim}
set ::bali::simulation::Para(PROJECTPATH) {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/sim}
set ::bali::simulation::Para(FILELIST) {"C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/parallel2byte_8s_1s_43.vo" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/packetheader_1s.vo" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/crc16_1lane.vo" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/colorbar_gen.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/IO_Controller_TX.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/oDDRx4.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/DPHY_TX_INST.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/LP_HS_dly_ctrl.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/BYTE_PACKETIZER.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/IPExpress/pll_pix2byte_YUV422_8bit_1lane.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/top.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/tb/Parallel2CSI2_tb_1lane.v" "C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_1lane_XO2_V6/rtl/compiler_directives.v" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"" "" "" "work" "work" "work" "work" "work" "work" "work" "work" "" "work" }
set ::bali::simulation::Para(COMPLIST) {"none" "none" "none" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "none" "VERILOG" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_machxo2}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {Parallel2CSI2_tb}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {VERILOG}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(HDLPARAMETERS) {}
set ::bali::simulation::Para(POJO2LIBREFRESH)    {}
set ::bali::simulation::Para(POJO2MODELSIMLIB)   {}
::bali::simulation::ActiveHDL_Run
