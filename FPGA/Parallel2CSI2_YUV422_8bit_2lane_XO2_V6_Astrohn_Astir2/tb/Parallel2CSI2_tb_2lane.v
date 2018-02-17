`timescale 1ns / 10ps

module Parallel2CSI2_tb();
	parameter periode_1     = 16;
	
	GSR GSR_INST(.GSR(1'b1));
    PUR PUR_INST(.PUR(1'b1)); 
	
	reg rstn;
	reg pixclk;
	wire DCK, D0, D1; 
	wire [1:0] LPCLK, LP1, LP0;
	wire fv, lv;
	wire [7:0] pixdata;
	
	
	initial begin                       
      rstn       = 1'b0; 
	  #1600;
	  #1600 rstn = 1'b1;  
	end
	initial
		  pixclk     = 1'b0;
	always pixclk    = #periode_1  ~pixclk; 
		
	top #(
     .VC(0)             ,
     .WC('h01E0)        ,
     .word_width(8)    ,
     .DT(6'h1E)         ,  
     .testmode  (0)     , 
     .crc16     (1)     ,  
     .reserved  (0)                
    ) u_top(
     .reset_n      (rstn)             ,
                                         
     .PIXCLK       (pixclk)             ,
     .FV           (fv)                 ,
     .LV           (lv)                 ,
     .PIXDATA      (pixdata)            ,
                                         
     .DCK          (DCK)                ,        //HS (High Speed) Clock                            
                                                                                                                                         
     //.D3           ()    ,      //HS (High Speed) Data Lane 3         
     //.D2           ()    ,      //HS (High Speed) Data Lane 2         
     .D1           (D1)    ,      //HS (High Speed) Data Lane 1         
     .D0           (D0)    ,      //HS (High Speed) Data Lane 0         
 	 
     .LPCLK        (LPCLK)    ,                                                                                               
     //.LP3          ()    ,        //LP (Low Power) External Interface Signals for Data Lane 3    
     //.LP2          ()    ,        //LP (Low Power) External Interface Signals for Data Lane 2    
     .LP1          (LP1)    ,        //LP (Low Power) External Interface Signals for Data Lane 1    
     .LP0          (LP0)            //LP (Low Power) External Interface Signals for Data Lane 0    
);
	colorbar_gen 	#(
	        .h_active  ('d480 ),
	        .h_total   ('d800 ),
	        .v_active  ('d800 ),
	        .v_total   ('d830 ),
	        .H_FRONT_PORCH ('d40),
            .H_SYNCH       ('d44),
            .V_FRONT_PORCH ('d5),
            .V_SYNCH       ('d5),
            .mode          (1)
        ) u_colorbar_gen
        ( 
            .rstn       (rstn  ) , 
            .clk        (pixclk) ,
			.fv         (fv) , 
            .lv         (lv) , 
            .data       (pixdata),
            .vsync      (),
            .hsync      ()
        );
     
endmodule
	   
	   