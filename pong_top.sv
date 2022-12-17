module full_ping_pong_game
(
	input clk,reset_n,
	input [1:0] btn,
	output logic vga_hsync,vga_vsync,
	output logic [2:0] vga_rgb
);
//state declaration
typedef enum {NEW_GAME,
				PLAY,
				NEW_BALL,
				OVER,
				XXX} state_e;
//signal declaration
state_e current_state,next_state;
logic [9:0] pixel_x,pixel_y;
logic video_on,graph_on,graph_still,hit,miss;
logic [3:0] text_on;
logic [2:0] text_rgb,graph_rgb;
logic [2:0] rgb_reg,rgb_next;
logic [3:0] dig_0,dig_1;
logic timer_tick,timer_up,timer_start;
logic [1:0] ball_reg,ball_next;
logic [1:0] btn_db;
logic d_inc,d_clr;

//instantiations
db_fsm db_fsm_inst_0
(.clk(clk), .reset_n(reset_n), .sw(~btn[0]), 
	 .db_level(btn_db[0]));

db_fsm db_fsm_inst_1
(.clk(clk), .reset_n(reset_n), .sw(~btn[1]), 
	 .db_level(btn_db[1]));

vga_sync vga_sync_inst
(
	.clk(clk), .rst_n(reset_n), .hsync(vga_hsync),.vsync(vga_vsync),
	.pixel_x(pixel_x),.pixel_y(pixel_y),.video_on(video_on)
);

pong_text_subsystem pong_text_subsystem_inst
(	.clk(clk),
	.balls_left_dig(ball_reg),
	.score_dig_0(dig_0), .score_dig_1(dig_1),
	.pixel_x(pixel_x),.pixel_y(pixel_y),
	.text_on(text_on),
	.text_rgb(text_rgb)
);

pong_graph_subsystem pong_graph_subsystem_inst
(	.clk(clk), .reset(~reset_n),
	.graph_on(graph_on),
	.btn(btn_db), .gra_still(graph_still),
	.pix_x(pixel_x),.pix_y(pixel_y),
	.miss(miss),.hit(hit),
	.graph_rgb(graph_rgb)
);

m100_counter m100_counter_inst
(	.clk(clk), .reset_n(reset_n),
	.d_inc(d_inc),.d_clr(d_clr),
	.dig_0(dig_0),
	.dig_1(dig_1)
);
assign timer_tick = (pixel_x==0) && (pixel_y==0);
timer timer_inst
(	.clk(clk), .reset_n(reset_n),
	.timer_tick(timer_tick),
	.timer_start(timer_start),
	.timer_up(timer_up)
);

//state machine
always_ff @(posedge clk or negedge reset_n) begin : proc_registers
	if(~reset_n) begin
		current_state <= NEW_GAME;
		ball_reg <= 0;
		rgb_reg <= 0;
	end else begin
		current_state <= next_state;
		ball_reg <= ball_next;
		rgb_reg <= rgb_next;
	end
end
always_comb begin : proc_next_state
	graph_still = '1;
	timer_start = '0;
	d_inc = '0;
	d_clr = '0;
	next_state = XXX;
	ball_next = ball_reg;
	case(current_state)
		NEW_GAME:
		begin
			ball_next = 2'b11;
			d_clr = '1;
			if(btn_db != 2'b00)
			begin
				next_state = PLAY;
				//ball_next = ball_reg - 1;
			end
			else
				next_state = NEW_GAME; //@ loopback
		end
		PLAY:
		begin
			graph_still = '0;
			if(hit) begin
				d_inc = '1;
				next_state = PLAY; //@ loopback				
			end
			else if(miss)
			begin
				if(ball_reg == 1)
					next_state = OVER;
				else
					next_state = NEW_BALL;
				timer_start = '1;
				ball_next = ball_reg-1;
			end
			else
				next_state = PLAY; //@ loopback
		end
		NEW_BALL:
		begin
			if(btn_db!=2'b00)
				next_state = PLAY;
			else
				next_state = NEW_BALL; // @loopback
		end
		OVER:
		begin
			if(btn_db!=2'b00)
				next_state = NEW_GAME;
			else
				next_state = OVER; // @loopback
		end
	endcase // current_state
end
//rgb multiplexing
always_comb begin : proc_rgb_multiplexing
	if(!video_on)
		rgb_next = '0;
	else
		if(text_on[3] ||
			(text_on[1] && (current_state == NEW_GAME)) ||
			(text_on[0] && (current_state == OVER)))
			rgb_next = text_rgb;
		else if(graph_on)
			rgb_next = graph_rgb;
		else if(text_on[2])
			rgb_next = text_rgb;
		else 
			rgb_next = 3'b110;
end

assign vga_rgb = rgb_reg;
endmodule