
module sony_block_to_yuv422_csi(
	//input clock_in,
	input [15:0] data_in,
	output reg [7:0] data_out,
	output clock_out,
	input clock_in,
	output reg FV,
	output reg LV
	);

pll_sony_block_cam_interface plldoubler(.CLKI(clock_in), .CLKOP(clock_out));

always @ (posedge clock_out) begin
	
end

reg [2:0] state = 0;

reg [12:0] pixcounter = 0;

reg tmp_LV = 0;

always @ (posedge clock_out) begin
	if(clock_in == 1) begin
		data_out <= data_in[15:8];//data_in[7:0];	
	end
	else begin
		data_out <= data_in[7:0];//data_in[15:8];	
	end
	
	//LV <= tmp_LV;
	
	if(LV == 1) begin
		pixcounter <= pixcounter + 1;
	end
	
	if(pixcounter == 3839) begin
		LV <= 0;
		tmp_LV <= 0;
	end
	
	if(state == 0 && data_out == 8'hFF)
		state <= 1;
	else if(state == 1 && data_out == 8'hFF)
		state <= 2;
	else if(state == 2 && data_out == 8'h00)
		state <= 3;
	else if(state == 3 && data_out == 8'h00)
		state <= 4;
	else if(state == 4 && data_out == 8'h00)
		state <= 5;
	else if(state == 5 && data_out == 8'h00)
		state <= 6;
	else if(state == 6)
		state <= 7;
	else if(state == 7 && data_out == 8'h9D) begin
		state <= 0;
		FV <= 1;
	end
	else if(state == 7 && data_out == 8'hAB) begin
		state <= 0;
		FV <= 0;
	end
	else if(state == 7 && data_out == 8'h9D) begin
		state <= 0;
		FV <= 1;
	end
	else if(state == 7 && data_out == 8'h80 && FV == 1) begin
		state <= 0;
		LV <= 1;
		pixcounter <= 0;
	end
	else
		state <= 0;
	
end

endmodule
