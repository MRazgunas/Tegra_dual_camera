lappend auto_path "C:/lscc/diamond/3.4_x64/data/script"
package require simulation_generation
set ::bali::simulation::Para(PROJECT) {simulation}
set ::bali::simulation::Para(PROJECTPATH) {D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/sim}
set ::bali::simulation::Para(FILELIST) {"D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/parallel2byte_8s_4s_30.vo" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/packetheader_4s.vo" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/crc16_4lane.vo" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/colorbar_gen.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/IO_Controller_TX.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/oDDRx4.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/DPHY_TX_INST.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/LP_HS_dly_ctrl.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/BYTE_PACKETIZER.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/IPExpress/pll_pix2byte_YUV422_8bit_4lane.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/top.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/Parallel2CSI2_YUV422_8bit_4lane_XO2/tb/Parallel2CSI2_tb_4lane.v" "D:/mipi_modified/SEND_DIRECTLY/CSI2_TX/XO2/Parallel2CSI2_YUV422_8bit_4lane_XO2_V6/rtl/compiler_directives.v" }
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
