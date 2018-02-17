// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2013 by Lattice Semiconductor Corporation
// --------------------------------------------------------------------
//
// Permission:
//
//   Lattice Semiconductor grants permission to use this code for use
//   in synthesis for any Lattice programmable logic product.  Other
//   use of this code, including the selling or duplication of any
//   portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL or Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Lattice Semiconductor provides no warranty
//   regarding the use or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Lattice Semiconductor Corporation
//                     5555 NE Moore Court
//                     Hillsboro, OR 97214
//                     U.S.A
//
//                     TEL: 1-800-Lattice (USA and Canada)
//                          408-826-6000 (other locations)
//
//                     web: http://www.latticesemi.com/
//                     email: techsupport@latticesemi.com
//
// --------------------------------------------------------------------
//
// top.v -- Parallel to CSI2 TX Bridge Reference Design
// 
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| APPS_LHQ          :| 05/30/12  :| Initial Release
//------------------------------------------------------------------------------------------------------------------------------------------

`include "../../rtl/compiler_directives.v"

module top #(
     parameter              VC         = 0             ,  //2-bit Virtual Channel Number
     parameter              WC         = 16'h0F00      ,  //16-bit Word Count in byte packets.  16'h05A0 = 16'd1440 bytes = 1440 * (8-bits per byte) / (24-bits per pixel for RGB888) = 480 pixels
     parameter              word_width = 8            ,  //Pixel Bus Width.  Example: RGB888 = 8-bits Red, 8-bits Green, 8-bits Blue = 24 bits/pixel
	 parameter				prim_word_width = 16	   , //Input pix bus width
     parameter              DT         = 6'h1E         ,  //6-bit MIPI CSI2 Data Type.  Example: dt = 6'h2B = RAW10
     parameter              testmode   = 0             ,  //adds colorbar pattern generator for testing purposes.  Operates off of PIXCLK input clock and reset_n input reset
     parameter              crc16      = 1             ,  //appends 16-bit checksum to the end of long packet transfers.  0 = off, 1 = on.  Turning off will append 16'hFFFF to end of long packet.  Turning off will reduce resource utilization.
     parameter              reserved   = 0                //reserved=0 at all times
)(
     input                  reset_n                    ,  // resets design (active low)
                                                                          
     output                 DCK                        ,  // HS (High Speed) Clock                            
                                                                         
     `ifdef HS_3                                                                      
          output        D3                             ,  //HS (High Speed) Data Lane 3         
          output        D2                             ,  //HS (High Speed) Data Lane 2         
          output        D1                             ,  //HS (High Speed) Data Lane 1         
          output        D0                             ,  //HS (High Speed) Data Lane 0         
 
     `elsif HS_2 
          output        D2                             ,      
          output        D1                             ,
          output        D0                             ,
                                                       
     `elsif HS_1                                       
          output        D1                             ,
          output        D0                             ,
                                                       
     `elsif HS_0                                       
          output        D0                             ,                  
     `endif                                            
     `ifdef LP_CLK                                     
          inout   [1:0] LPCLK                          ,  //LP (Low Power) External Interface Signals for Clock Lane     
     `endif                                                                                                              
     `ifdef LP_3                                                                                                         
          inout   [1:0] LP3                            ,  //LP (Low Power) External Interface Signals for Data Lane 3    
     `endif                                                                                                              
     `ifdef LP_2                                                                                                         
          inout   [1:0] LP2                            ,  //LP (Low Power) External Interface Signals for Data Lane 2    
     `endif                                                                                                              
     `ifdef LP_1                                                                                                         
          inout   [1:0] LP1                            ,  //LP (Low Power) External Interface Signals for Data Lane 1    
     `endif                                                                                                              
     `ifdef LP_0                                                                                                         
          inout   [1:0] LP0                            ,  //LP (Low Power) External Interface Signals for Data Lane 0    
     `endif                                                                                                               
                                                       
     input                  PIXCLK                     ,  //Pixel clock input for parallel interface
//     output                  FV                         ,  //Frame Valid input for parallel interface
//     input                  LV                         ,  //Line Valid input for parallel interface
     input [prim_word_width-1:0] PIXDATA                       //Pixel data bus for parallel interface
);
     wire [7:0] byte_D3, byte_D2, byte_D1, byte_D0;
     wire [7:0] byte_D3_out, byte_D2_out, byte_D1_out, byte_D0_out;
     wire [15:0] word_cnt;
     wire [1:0] lp_clk;
     wire [1:0] lp_data;
     wire [word_width-1:0] w_pixdata;
     wire w_pixclk, byte_clk, CLKOP, CLKOS;

     parameter  lane_width = `ifdef HS_3  4
                             `elsif HS_2  3
                             `elsif HS_1  2
                             `elsif HS_0  1
                             `endif ;  
                             
generate
    if(DT=='h1E & lane_width==1) 
         pll_pix2byte_YUV422_8bit_1lane u_pll_pix2byte_YUV422_8bit_1lane(.RST(~reset_n), .CLKI(w_pixclk), .CLKOP(CLKOP), .CLKOS(CLKOS), .CLKOS2(byte_clk), .LOCK());
endgenerate
generate
    if(DT=='h1E & lane_width==2) 
         pll_pix2byte_YUV422_8bit_2lane u_pll_pix2byte_YUV422_8bit_2lane(.RST(~reset_n), .CLKI(w_pixclk), .CLKOP(CLKOP), .CLKOS(CLKOS), .CLKOS2(byte_clk), .LOCK());
endgenerate
generate
    if(DT=='h1E & lane_width==4) 
         pll_pix2byte_YUV422_8bit_4lane u_pll_pix2byte_YUV422_8bit_4lane(.RST(~reset_n), .CLKI(w_pixclk), .CLKOP(CLKOP), .CLKOS(CLKOS), .CLKOS2(byte_clk), .LOCK());
endgenerate
     
     assign word_cnt = w_lv ? WC : 16'h0000;
     
     BYTE_PACKETIZER #(
          .word_width(word_width) ,
          .lane_width(lane_width) ,
          .dt        (DT        ) ,
          .crc16     (crc16     )   
     )
     u_BYTE_PACKETIZER (
          .reset_n         (reset_n)    ,
          .PIXCLK          (w_pixclk)   ,
          .FV              (w_fv   )    ,
          .LV              (w_lv   )    ,
          .PIXDATA         (w_pixdata)  ,
                                      
          .VC              (VC)       ,
          .WC              (word_cnt)       ,
          
          .byte_clk        (byte_clk) ,    
          
          .hs_en           (hs_en)    ,
          .byte_D3         (byte_D3)  ,
          .byte_D2         (byte_D2)  ,
          .byte_D1         (byte_D1)  ,
          .byte_D0         (byte_D0)      
     );
    
     //LP_HS_DELAY_CNTRL #(
         //.LPHS_clk2data_dly    (5),
         //.LPHS_startofdata_dly (5),
         //.HSLP_data2clk_dly    (7),
         //.HSLP_endofdata_dly   (7),
         //.sizeofstartcntr      (6), //number of bits to count LPHS_clk2data_dly+LPHS_startofdata_dly
         //.sizeofendcntr        (6)  //number of bits to count HSLP_data2clk_dly+HSLP_endofdata_dly
     //)
     //u_LP_HS_DELAY_CNTRL(
         //.reset_n   (reset_n),
         //.byte_clk  (byte_clk),
         //.hs_en     (hs_en),
         //.byte_D3_in(byte_D3),
         //.byte_D2_in(byte_D2),
         //.byte_D1_in(byte_D1),
         //.byte_D0_in(byte_D0),
         //.lp_clk  (lp_clk),
         //.lp_data (lp_data),
         //.byte_D3_out(byte_D3_out),
         //.byte_D2_out(byte_D2_out),
         //.byte_D1_out(byte_D1_out),
         //.byte_D0_out(byte_D0_out)
//);



LP_HS_DELAY_CNTRL  u_LP_HS_DELAY_CNTRL
(
    .reset_n (reset_n)          ,
    .byte_clk(byte_clk)         ,
    .hs_en   (hs_en)             ,
    .byte_D3_in(byte_D3)              ,
    .byte_D2_in(byte_D2)              ,
    .byte_D1_in(byte_D1)              ,
    .byte_D0_in(byte_D0)              ,
    
    .hs_clk_en  (hs_clk_en)               ,
    .hsxx_clk_en(hsxx_clk_en)         ,
    .hs_data_en (hs_data_en)          ,
    .lp_clk     (lp_clk)               ,
    .lp_data    (lp_data)          ,
    .byte_D3_out(byte_D3_out)               ,
    .byte_D2_out(byte_D2_out)               ,
    .byte_D1_out(byte_D1_out)               ,
    .byte_D0_out(byte_D0_out)             
);

     DPHY_TX_INST u_DPHY_TX_INST (
          .reset_n         (reset_n)       ,      //Resets the Design                   
                                                                                     
          .DCK             (DCK)           ,      //HS (High Speed) Clock         
          .CLKOP           (CLKOP)         ,      //Byte Clock                    
          .CLKOS           (CLKOS)         ,
                                                                                   
          `ifdef HS_3                                                                   
               .D3         (D3)            ,      //HS (High Speed) Data Lane 3         
               .D2         (D2)            ,      //HS (High Speed) Data Lane 2         
               .D1         (D1)            ,      //HS (High Speed) Data Lane 1         
               .D0         (D0)            ,      //HS (High Speed) Data Lane 0         
               .byte_D3    (byte_D3_out)   ,      //HS (High Speed) Byte Data, Lane 3   
               .byte_D2    (byte_D2_out)   ,      //HS (High Speed) Byte Data, Lane 2   
               .byte_D1    (byte_D1_out)   ,      //HS (High Speed) Byte Data, Lane 1   
               .byte_D0    (byte_D0_out)   ,      //HS (High Speed) Byte Data, Lane 0   
          `elsif HS_2      
               .D2         (D2)            ,      
               .D1         (D1)            ,
               .D0         (D0)            ,
               .byte_D2    (byte_D2_out)   ,
               .byte_D1    (byte_D1_out)   ,
               .byte_D0    (byte_D0_out)   ,        
          `elsif HS_1                      
               .D1         (D1)            ,
               .D0         (D0)            ,
               .byte_D1    (byte_D1_out)   ,
               .byte_D0    (byte_D0_out)   ,            
          `elsif HS_0                      
               .D0         (D0)            ,
               .byte_D0    (byte_D0_out)   ,                       
          `endif                           
          `ifdef LP_CLK                    
               .LPCLK      (LPCLK)         ,        
               .lpclk_out  (lp_clk)        ,        
               .lpclk_in   ()              ,        
               .lpclk_dir  (1'b1)          ,        
          `endif                                              
          `ifdef LP_3                                         
               .LP3        (LP3)           ,        
               .lp3_out    (lp_data)       ,        
               .lp3_in     ()              ,        
               .lp3_dir    (1'b1)          ,        
          `endif                                              
          `ifdef LP_2                                         
               .LP2        (LP2)           ,        
               .lp2_out    (lp_data)       ,        
               .lp2_in     ()              ,        
               .lp2_dir    (1'b1)          ,        
          `endif                                              
          `ifdef LP_1                                         
               .LP1        (LP1)           ,        
               .lp1_out    (lp_data)       ,        
               .lp1_in     ()              ,        
               .lp1_dir    (1'b1)          ,        
          `endif                                              
          `ifdef LP_0                                         
               .LP0        (LP0)           ,        
               .lp0_out    (lp_data)       ,        
               .lp0_in     ()              ,        
               .lp0_dir    (1'b1)          ,        
          `endif                                         
             //  .hs_clk_en  (~(|lp_clk) )   ,                                 
             //  .hs_data_en (~(|lp_data))
			   
			   .hs_clk_en  ( hs_clk_en )   ,
               .hsxx_clk_en(hsxx_clk_en ),			   
               .hs_data_en ( hs_data_en )


); 

generate
    if(testmode==1) begin
        colorbar_gen 	#(
	        .h_active  ('d480 ),
	        .h_total   ('d620 ),
	        .v_active  ('d800 ),
	        .v_total   ('d830 ),
	        .H_FRONT_PORCH ('d40),
            .H_SYNCH       ('d44),
            .V_FRONT_PORCH ('d5),
            .V_SYNCH       ('d5)
        ) u_colorbar_gen
        ( 
            .rstn       (reset_n  ) , 
            .clk        (w_pixclk) , 
            .fv         (w_fv) , 
            .lv         (w_lv) , 
            .data       (w_pixdata),
            .vsync      (),
            .hsync      ()
        );
    end
    else begin
        //assign w_pixclk  = PIXCLK;
        //assign w_lv      = LV;  
        //assign FV      = w_lv;//w_fv;
        //assign w_pixdata = PIXDATA;
		sony_block_to_yuv422_csi u_sony_block_to_yuv422_csi(
			.data_in(PIXDATA),
			.data_out(w_pixdata),
			.clock_out(w_pixclk),
			.clock_in(PIXCLK),
			.FV(w_fv),
			.LV(w_lv));
    end
endgenerate

generate
    if(reserved==1) begin
        OSCH #(.NOM_FREQ("20.46")) u_OSCH(.STDBY(0),.OSC(w_pixclk));  //reserved for internal use only
    end
    else begin
        //assign w_pixclk  = PIXCLK;
    end
endgenerate
endmodule