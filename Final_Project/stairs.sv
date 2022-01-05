
// This module is used to generate stairs
module stair ( input Clk, Reset,
					input frame_clk,  
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [19:0]  random_num,
					input [9:0]  distance,
					input [13:0]  move_message, active_message, tool_message,
					output logic [13:0][9:0]  stair_x, stair_y,
					output logic [9:0]stair_size,   
					output logic  is_stair,
					output logic [3:0] counter,
					output logic [13:0][9:0] tool_x, tool_y, tool_size
					);	
					
    parameter [9:0] X_Min = 10'd160;       // Leftmost point on the X axis
    parameter [9:0] X_Max = 10'd479;       // Rightmost point on the X axis
	 
	 logic[13:0] check;
	 assign stair_size = 10'd20; // Stair size
	 logic[13:0][9:0] stair_x_in;
	 
	 
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 // The movement of the stairs
    always_ff @ (posedge Clk) 
	 begin
		 for (int j=0; j<14; j++)
		 begin
			 if (stair_x[j] + stair_size >= X_Max)
				 begin
					 stair_x_in[j] <= -1;
				 end
			 else if(stair_x[j] - stair_size <= X_Min)
				 begin
					 stair_x_in[j] <= 1;
				 end
			 else
				 stair_x_in[j] <= stair_x_in[j];
		end
	 end
	 
	 

    always_ff @ (posedge Clk) 
	 begin
		if(Reset)		// initiallize
			begin		
				 stair_x[0] <= 10'd240;
				 stair_y[0] <= 10'd30;
				 
				 stair_x[1] <= 10'd340;
				 stair_y[1] <= 10'd60;
				 
				 stair_x[2] <= 10'd200;
				 stair_y[2] <= 10'd90;
				 
				 stair_x[3] <= 10'd260;
				 stair_y[3] <= 10'd120;
				 
				 stair_x[4] <= 10'd460;
				 stair_y[4] <= 10'd150;
				 
				 stair_x[5] <= 10'd220;
				 stair_y[5] <= 10'd180;
				 
				 stair_x[6] <= 10'd440;
				 stair_y[6] <= 10'd210;
				 
				 stair_x[7] <= 10'd320;
				 stair_y[7] <= 10'd240;
	
				 stair_x[8] <= 10'd420;
				 stair_y[8] <= 10'd270;
				 
				 stair_x[9] <= 10'd360;
				 stair_y[9] <= 10'd330;
				 
				 stair_x[10] <= 10'd380;
				 stair_y[10] <= 10'd360;
				 
				 stair_x[11] <= 10'd160;
				 stair_y[11] <= 10'd390;
				 
				 stair_x[12] <= 10'd300;
				 stair_y[12] <= 10'd420;
				 
				 stair_x[13] <= 10'd400;
				 stair_y[13] <= 10'd450;
			end
		else
			begin
			 for (int j=0; j<14; j++)
				begin
					stair_y[j] <= stair_y[j] - distance;
					if (stair_y[j] > 10'd479)				// If a stair is disappeared, randomly generate a new one from the top
						begin
							if (active_message[j])			// check if the stair is active
							begin
								stair_x[j] <= random_num[9:0];  
								stair_y[j] <= 10'b0;
							end
							else									// not active, move out of screen
							begin
								stair_x[j] <= 10'd500;  
								stair_y[j] <= 10'd600;
							end
						end	
				end
			if (frame_clk_rising_edge)
				for (int j=0; j<14; j++)
					begin
						if (move_message[j])
							stair_x[j] <= stair_x[j] + stair_x_in[j];
					end
			end
    end
	 
	 always_comb 
	 begin
		 for (int j=0; j<14; j++)
		 begin
				if (tool_message[j])
				begin
					tool_x[j] = stair_x[j];
					tool_y[j] = stair_y[j] - 10'd10;
					tool_size[j] = 10'd7;
				end
				else
				begin
					tool_x[j] = stair_x[j];
					tool_y[j] = stair_y[j] - 10'd10;
					tool_size[j] = 10'd0;
				end
		 end
	 end
	 

	 // Is stair signal checks if the present pixel belongs to one of the stairs
	 always_comb 
	 begin
		  for (int j=0; j<14; j++)
			begin
				check[j] = ( DrawX <= stair_x[j] +stair_size && DrawX >= stair_x[j] + ~stair_size + 10'b1 ) && ( (DrawY <= stair_y[j] + 10'd5) && (DrawY >= stair_y[j] + ~10'd5 + 10'b1));
			end
		  
		  if (check[0] || check[1] || check[2] || check[3] || check[4] || check[5] || check[6] || check[7] || check[8] || check[9] || check[10] || check[11] || check[12] || check[13] )
				is_stair = 1'b1;
		  else
				is_stair = 1'b0;
	 end
	 
endmodule