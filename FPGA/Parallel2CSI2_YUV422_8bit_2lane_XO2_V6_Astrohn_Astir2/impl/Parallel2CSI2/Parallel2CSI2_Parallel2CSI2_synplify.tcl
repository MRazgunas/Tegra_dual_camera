#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology MACHXO2
set_option -part LCMXO2_4000HC
set_option -package BG256C
set_option -speed_grade -6

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency 200
set_option -maxfan 100
set_option -auto_constrain_io 1
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe false
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false
set_option -frequency 1
set_option -default_enum_encoding default

#simulation options


#timing analysis options
set_option -num_critical_paths 3
set_option -num_startend_points 0

#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 1


#-- add_file options
set_option -include_path {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/impl}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/compiler_directives.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/IPExpress/pll_pix2byte_YUV422_8bit_2lane.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/top.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/DPHY_TX_INST.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/IO_Controller_TX.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/oDDRx4.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/colorbar_gen.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/LP_HS_dly_ctrl.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/BYTE_PACKETIZER.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/crc16_2lane_bb.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/packetheader_bb.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/parallel2byte_bb.v}
add_file -verilog {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/rtl/astrohn_astir2.v}

#-- top module name
set_option -top_module top

#-- set result format/file last
project -result_file {C:/Users/matas/Documents/GitHub/Tegra_dual_camera/FPGA/Parallel2CSI2_YUV422_8bit_2lane_XO2_V6_Astrohn_Astir2/impl/Parallel2CSI2/Parallel2CSI2_Parallel2CSI2.edi}

#-- error message log file
project -log_file {Parallel2CSI2_Parallel2CSI2.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run
