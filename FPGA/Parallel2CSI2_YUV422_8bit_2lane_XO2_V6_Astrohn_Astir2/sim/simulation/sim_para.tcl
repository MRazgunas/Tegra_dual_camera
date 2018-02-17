lappend auto_path "C:/lscc/diamond/3.2_x64/data/script"
package require simulation_generation
set ::bali::simulation::Para(PROJECT) {simulation}
set ::bali::simulation::Para(PROJECTPATH) {C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/sim}
set ::bali::simulation::Para(FILELIST) {"C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/parallel2byte_8s_2s_30.vo" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/packetheader_2s.vo" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/crc16_2lane.vo" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/colorbar_gen.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/IO_Controller_TX.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/oDDRx4.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/DPHY_TX_INST.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/LP_HS_dly_ctrl.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/BYTE_PACKETIZER.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/IPExpress/pll_pix2byte_YUV422_8bit_2lane.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/top.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/Parallel2CSI2_YUV422_8bit_2lane_XO2/tb/Parallel2CSI2_tb_2lane.v" "C:/Users/rjohn/Desktop/New folder (4)/Parallel2CSI2_YUV422_8bit_2lane_XO2_V5/rtl/compiler_directives.v" }
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
set ::bali::simulation::Para(POJO2LIBREFRESH)    {}
set ::bali::simulation::Para(POJO2MODELSIMLIB)   {}
::bali::simulation::ActiveHDL_Run
