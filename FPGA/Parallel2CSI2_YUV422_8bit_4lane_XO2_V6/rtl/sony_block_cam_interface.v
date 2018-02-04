
module sony_block_to_yuv422_csi(
	//input clock_in,
	input [15:0] data_in,
	output reg [7:0] data_out,
	output clock_out,
	input clock_in,
	output reg FV,
	output reg LV
	);

reg [1:0] state = 0;

reg [11:0] pixcounter = 0;
reg [7:0] fv_del_counter = 0;
reg w_fv = 0;

reg [1:0] frame_state = 0;

pll_sony_block_cam_interface plldoubler(.CLKI(clock_in), .CLKOP(clock_out));

always @ (posedge clock_in) begin
	if(state == 0 && data_in == 16'hFFFF) begin
		state <= 1;
	end
	else if(state == 1 && data_in == 0) begin
		state <= 2;
	end
	else if(state == 2 && data_in == 0) begin
		state <= 3;
	end
	else if(state == 3 && data_in == 16'h9D9D) begin
		state <= 0;
		//LV <= 0;
	end
	else if(state == 3 && data_in == 16'hABAB) begin
		state <= 0;
		w_fv <= 0;
	end
	else if(state == 3 && data_in == 16'h8080) begin
		state <= 0;
		LV <= 1;
		FV <= 1;
		w_fv <= 1;
		fv_del_counter <= 0;
	end
	else if(state == 3 && data_in == 16'hB6B6) begin
		state <= 0;
		//LV <= 0;
		w_fv <= 0;
	end
	else begin 
		state <= 0;
	end
	
	if(w_fv == 0 && fv_del_counter < 254) begin
		fv_del_counter <= fv_del_counter + 1;
	end
	
	if(fv_del_counter == 250) begin
		FV <= 0;
	end
	
	if(LV == 1) begin
		pixcounter <= pixcounter+1;
	end
	
	if(pixcounter == 1921) begin
		pixcounter <= 0;
		LV <= 0;
	end
		
end
	

always @ (posedge clock_out) begin
	if(clock_in == 1) begin
		data_out <= data_in[15:8];//data_in[7:0];
	end
	else
		data_out <= data_in[7:0];//data_in[15:8];		
end

endmodule
