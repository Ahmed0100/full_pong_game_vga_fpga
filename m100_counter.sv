module m100_counter
(
	input clk,reset_n,
	input d_inc,d_clr,
	output logic [3:0] dig_0,dig_1
);

logic [3:0] dig_0_reg,dig_0_next,dig_1_reg,
dig_1_next;

always_ff @(posedge clk or negedge reset_n) begin : registers
	if(~reset_n)
	begin
		dig_0_reg<=0;
		dig_1_reg <= 0;
	end 
	else
	begin
		dig_1_reg <= dig_1_next;
		dig_0_reg <= dig_0_next;
	end
end

always_comb begin : proc_next_state
	dig_0_next = dig_0_reg;
	dig_1_next = dig_1_reg;
	if(d_clr)
	begin
		dig_0_next = 0;
		dig_1_next = 0;
	end
	else if(d_inc)
	begin
		if(dig_0_reg == 9)
		begin
			dig_0_next = 0;
			if(dig_1_reg == 9)
				dig_1_next = 0;
			else 
				dig_1_next = dig_1_reg + 1;
		end
		else
			dig_0_next = dig_0_reg + 1;
	end
end
//outputs
assign dig_0 = dig_0_reg;
assign dig_1 = dig_1_reg;

endmodule