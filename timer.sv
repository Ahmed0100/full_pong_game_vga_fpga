module timer
(
	input clk,reset_n,
	input timer_start,timer_tick,
	output logic timer_up
);

logic [6:0] timer_reg, timer_next;
always_ff @(posedge clk or negedge reset_n) begin : proc_timer_reg
	if(~reset_n) begin
		timer_reg <= '1;
	end else begin
		timer_reg <= timer_next;
	end
end
always_comb begin : proc_timer_next
	if(timer_start)
		timer_next = '1;
	else if(timer_tick && timer_reg != 0)
		timer_next = timer_reg - 1;
	else
		timer_next = timer_reg;
end
//outputs
assign timer_up = (timer_reg == 0);

endmodule