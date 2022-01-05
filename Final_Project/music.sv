module music (input logic  Clk,
				  input logic  [16:0]Add,
				  output logic [16:0]music_content
);
				  
	logic [16:0] music_memory [0:99549];
	initial 
	begin 
		$readmemh("mj.txt",music_memory);
	end
	
	always_ff @ (posedge Clk)
		begin
			music_content <= music_memory[Add];
		end
endmodule
