
//-------------------------------------------------------------------------
//      doodle_state.sv                                                  --
//      Created by Lai Xinyi & Yuqi Yu.                                  --
//      Modified by Yuhao Ge & Haina Lou                                  --
//      Fall 2021                                                        --
//                                                                       --
//      This module is used control whether to used different picture to draw the doodle 
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
module score ( 	input		Clk,               
							Reset,             
				input logic [2:0]show,			//if turn to dead page score show in other place
				input [9:0] DrawX, DrawY,       // Current pixel coordinates
				input [10:0] score_num, 	// distance/500 
				output logic is_score           // 1 if the score number exist
			  );



	logic [10:0] font_addr;
	logic [7:0] font_data;
	int Score1_X_Pos = 10'd180; 			//normal position
	int Score1_X_Pos_drop = 10'd360;		//dead page position 
	int Score1_Y_Pos = 10'd20;				
	int Score1_Y_Pos_drop = 10'd200;
	int Score2_X_Pos = 10'd200; 
	int Score2_X_Pos_drop = 10'd370;
	int Score2_Y_Pos = 10'd20;
	int Score2_Y_Pos_drop = 10'd200;

	//score position 
	int Score1_X_Pos_use;
	int Score2_X_Pos_use;
	int Score1_Y_Pos_use;
	int Score2_Y_Pos_use;


	logic score_on; // 1 means reach the data position

	
	always_comb
	begin 
	if (show == 3'd3)				//if turn to dead state
	begin
		Score1_X_Pos_use = Score1_X_Pos_drop;
		Score2_X_Pos_use= Score2_X_Pos_drop;
		Score1_Y_Pos_use= Score1_Y_Pos_drop;
		Score2_Y_Pos_use= Score2_Y_Pos_drop;
	end
	else
	begin
		Score1_X_Pos_use = Score1_X_Pos;
		Score2_X_Pos_use= Score2_X_Pos;
		Score1_Y_Pos_use= Score1_Y_Pos;
		Score2_Y_Pos_use= Score2_Y_Pos;
	end
		
	end
	

	int digit1, digit2;	// two digits to represent score
	int dX, dY; 	//current pixel difference with start address
	

	always_comb
	begin
	digit1 = score_num/10;	//ten number
	digit2 = score_num%10;	//single number
	end

	always_comb begin

		if ( DrawX >=Score1_X_Pos_use && DrawX < Score1_X_Pos_use + 4'd8 &&
				DrawY >=Score1_Y_Pos_use && DrawY < Score1_Y_Pos_use + 5'd16) begin    
			score_on = 1'b1;
			dX = DrawX-Score1_X_Pos_use;
			dY = DrawY-Score1_Y_Pos_use;
			font_addr = dY + 5'd16* digit1;
		end

		 else if ( DrawX >=Score2_X_Pos_use && DrawX < Score2_X_Pos_use + 4'd8 &&
		 		DrawY >=Score2_Y_Pos_use && DrawY < Score2_Y_Pos_use + 5'd16) begin
		 	score_on = 1'b1;
		 	dX = DrawX-Score2_X_Pos_use;
		 	dY = DrawY-Score2_Y_Pos_use;
		 	font_addr = dX + 5'd16* digit2;
		 end

		else begin
			score_on = 1'b0;
			dX = 0;
			dY = 0;
			font_addr = 11'b0;
		end

	end

	digit_font my_digits(.addr(font_addr), .data(font_data));

	always_comb begin
		if (score_on==1'b1 && font_data[8-dX]== 1'b1)
			is_score = 1'b1;
		else
			is_score = 1'b0;
	end 

endmodule