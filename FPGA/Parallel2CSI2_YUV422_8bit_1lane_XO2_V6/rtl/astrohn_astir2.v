
module astrohn_astir2(
	input [7:0] data_in,
	input clock_in,
	output reg FV,
	output reg LV
	);

reg [1:0] state = 0;

reg [11:0] pixcounter = 0;
reg [8:0] linecount = 0;
reg [7:0] fv_del_counter = 0;
reg w_fv = 0;

reg [1:0] frame_state = 0;

always @ (posedge clock_in) begin
	if(state == 0 && data_in == 8'hFF) begin
		state <= 1;
	end
	else if(state == 1 && data_in == 0) begin
		state <= 2;
	end
	else if(state == 2 && data_in == 0) begin
		state <= 3;
	end
	else if(state == 3 && data_in == 8'h9D) begin
		state <= 0;
		//LV <= 0;
		FV <= 1;
		w_fv <= 1;
		fv_del_counter <= 0;
	end
	else if(state == 3 && data_in == 8'hAB) begin
		state <= 0;
		//LV <= 0;
		FV <= 0;
		linecount <= 0;
		w_fv <= 0;
		if(frame_state == 0) begin
			frame_state <= 1;
			//LV <= 1;
		end
	end
	else if(state == 3 && data_in == 8'h80) begin
		state <= 0;
		linecount <= linecount + 1;
		if(linecount < 480 && FV == 1) begin
			LV <= 1;
		end
		FV <= 1;
		w_fv <= 1;
		fv_del_counter <= 0;
		frame_state <= 0;
	end
	else if(state == 3 && data_in == 8'hB6) begin
		state <= 0;
		//LV <= 0;
		FV <= 0;
		linecount <= 0;
		w_fv <= 0;
		if(frame_state == 1) begin
			frame_state <= 2;
		end
		else if(frame_state == 2) begin
			//w_fv <= 0;
			//FV <= 0;
			frame_state <= 3;
		end
	end
	else begin 
		state <= 0;
	end
	
	if(w_fv == 0 && fv_del_counter < 254) begin
		fv_del_counter <= fv_del_counter + 1;
	end
	
	if(fv_del_counter == 250) begin
		//FV <= 0;
	end
	
	if(LV == 1) begin
		pixcounter <= pixcounter+1;
	end
	
	if(pixcounter == 1279) begin
		pixcounter <= 0;
		LV <= 0;
	end
		
end

endmodule
