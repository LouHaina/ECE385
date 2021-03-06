module  tot_distance ( input         Clk,Reset, drop,             // Active-high reset signal
							  input   [9:0] distance,
							  output logic [31:0] tot_distance
              );
				  
	 logic [31:0] sum;
				  
	 assign tot_distance = sum; 
				  
    always_ff @ (posedge Clk) 
	 begin
		 if (Reset)
			sum <= 0;
		 else if (drop)
			sum <= sum;
		 else 
		   sum <= sum + distance%1000;
	 end  
				  
				  
endmodule

