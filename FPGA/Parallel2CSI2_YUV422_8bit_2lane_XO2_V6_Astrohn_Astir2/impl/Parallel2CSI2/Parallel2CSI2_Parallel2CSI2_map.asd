[ActiveSupport MAP]
Device = LCMXO2-4000HC;
Package = CABGA256;
Performance = 6;
LUTS_avail = 4320;
LUTS_used = 529;
FF_avail = 4527;
FF_used = 339;
INPUT_LVCMOS25 = 2;
OUTPUT_LVCMOS12 = 6;
OUTPUT_LVCMOS25 = 2;
OUTPUT_LVDS25E = 3;
IO_avail = 207;
IO_used = 16;
EBR_avail = 10;
EBR_used = 1;
; Begin EBR Section
Instance_Name = u_BYTE_PACKETIZER/u_parallel2byte/u_fifo/pixel2byte_fifo_8to16_0_0;
Type = FIFO8KB;
Width = 16;
REGMODE = NOREG;
RESETMODE = ASYNC;
ASYNC_RESET_RELEASE = SYNC;
GSR = DISABLED;
; End EBR Section
; Begin PLL Section
Instance_Name = u_pll_pix2byte_YUV422_8bit_2lane/PLLInst_0;
Type = EHXPLLJ;
CLKOP_Post_Divider_A_Input = DIVA;
CLKOS_Post_Divider_B_Input = DIVB;
CLKOS2_Post_Divider_C_Input = DIVC;
CLKOS3_Post_Divider_D_Input = DIVD;
Pre_Divider_A_Input = VCO_PHASE;
Pre_Divider_B_Input = VCO_PHASE;
Pre_Divider_C_Input = VCO_PHASE;
Pre_Divider_D_Input = VCO_PHASE;
VCO_Bypass_A_Input = VCO_PHASE;
VCO_Bypass_B_Input = VCO_PHASE;
VCO_Bypass_C_Input = VCO_PHASE;
VCO_Bypass_D_Input = VCO_PHASE;
FB_MODE = CLKOP;
CLKI_Divider = 1;
CLKFB_Divider = 2;
CLKOP_Divider = 10;
CLKOS_Divider = 10;
CLKOS2_Divider = 40;
CLKOS3_Divider = 1;
Fractional_N_Divider = 0;
CLKOP_Desired_Phase_Shift(degree) = 0;
CLKOP_Trim_Option_Rising/Falling = RISING;
CLKOP_Trim_Option_Delay = 0;
CLKOS_Desired_Phase_Shift(degree) = 90;
CLKOS_Trim_Option_Rising/Falling = RISING;
CLKOS_Trim_Option_Delay = 0;
CLKOS2_Desired_Phase_Shift(degree) = 0;
CLKOS3_Desired_Phase_Shift(degree) = 0;
; End PLL Section
