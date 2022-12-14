module pong_graph_subsystem
(
	input clk,reset_n,
	input graph_on,
	input [1:0] btn,
	input graph_still,
	input [9:0] pixel_x,pixel_y,
	output reg miss,hit,
	output reg [2:0] graph_rgb
);
//signal declaration
localparam MAX_X=640;
localparam MAX_Y=480;
wire refresh_tick;
//wall boundaries
localparam WALL_X_L = 32;
localparam WALL_X_R = 35;

//vertical bar
localparam BAR_X_L = 600;
localparam BAR_X_R= 603;
wire [9:0] bar_y_t,bar_y_b;
localparam BAR_SIZE = 72;
reg [9:0] bar_y_reg,bar_y_next;
localparam BAR_V = 4;
//square ball
localparam BALL_SIZE = 8;
wire [9:0] ball_x_l,ball_x_r;
wire [9:0] ball_y_t,_ball_y_b;
reg [9:0] ball_x_reg,ball_x_next;
reg [9:0] ball_y_reg,ball_y_next;
reg [9:0] ball_x_delta_reg,ball_x_delta_next;
reg [9:0] ball_y_delta_reg,ball_y_delta_next;
localparam BALL_V_P = 2;
localparam BALL_V_N= -2;
//round ball
wire [2:0] rom_addr, rom_col;
reg [7:0] rom_data;
wire rom_bit;
//object signals
wire wall_on,bar_on,sq_ball_on,rd_ball_on;
wire [2:0] ball_rgb,bar_rgb,wall_rgb;
//body
//round ball rom
always @*
begin
 	case (rom_addr)
	    3'h0: rom_data = 8'b00111100; //   ****
	    3'h1: rom_data = 8'b01111110; //  ******
	    3'h2: rom_data = 8'b11111111; // ********
	    3'h3: rom_data = 8'b11111111; // ********
	    3'h4: rom_data = 8'b11111111; // ********
	    3'h5: rom_data = 8'b11111111; // ********
	    3'h6: rom_data = 8'b01111110; //  ******
	    3'h7: rom_data = 8'b00111100; //   ****
	endcase
end
//registers
always_ff @(posedge clk or negedge reset_n) begin
	if(~reset_n)
	begin
		bar_y_reg <= 0;
		ball_x_reg<=0;
		ball_y_reg<=0;
		ball_x_delta_reg <= 10'h4;
		ball_y_delta_reg <= 10'h4;
	end
	else
	begin
		bar_y_reg <= bar_y_next;  
		ball_x_reg <= ball_x_next;
		ball_y_reg <= ball_y_next;
		ball_x_delta_reg <=ball_x_delta_next;
		ball_y_delta_reg <=ball_y_delta_next;
	end
end
//refresh tick. 1-clock tick is asserted at start of v sync.
assign refresh_tick = (pixel_y ==481) &&(pixel_x == 0);
//wall
assign wall_on = (pixel_x >= WALL_X_L) && (pixel_y <= WALL_X_R);
assign wall_rgb = 3'b001;
//vertical bar
//boundary
assign bar_y_t = bar_y_reg;
assign bar_y_b = bar_y_t + BAR_SIZE - 1;
//pixel is within the bar region
assign bar_on (pixel_x >= BAR_X_L) && (pixel_x <= BAR_X_R) &&
(pixel_y >= bar_y_t) &&(pixel_y <= bar_y_b);

assign bar_rgb = 3'b010;

//new bar y position
always_comb begin
	bar_y_next = bar_y_reg;
	if(refresh_tick)
		if(btn[1] && (bar_y_b < (MAX_Y-1-BAR_V)))
			bar_y_next = bar_y_reg + BAR_V;
		else if(btn[0] && (bar_y_t > BAR_V))
			bar_y_next = bar_y_reg - BAR_V;
end
//square ball
//boundary
assign ball_x_l = ball_x_reg;
assign ball_x_r = ball_x_l + BALL_SIZE-1;
assign ball_x_t = ball_y_reg;
assign ball_x_b = ball_x_t + BALL_SIZE-1;
//pixel is within the ball region
assign sq_ball_on = (pixel_x >= ball_x_l ) && (pixel_x <= ball_x_r) &&
(pixel_y >= ball_y_t) && (pixel_y <= ball_y_b);
//map current pixel location to the round ball rom addr/col
assign rom_addr = pixel_y[2:0] - ball_y_t[2:0];
assign rom_col = pixel_x[2:0] - ball_x_l[2;0];
assign rom_bit = rom_data[rom_col];
//pixel is within square ball
assign rd_ball_on = sq_ball_on && rom_bit;
assign ball_rgb = 3'b100;
//new ball position
assign ball_x_next = (graph_still)? MAX_X /2: 
					(refresh_tick)? ball_x_reg + ball_x_delta_next:
					ball_x_reg;
assign ball_y_next = (graph_still)? MAX_Y /2: 
					(refresh_tick)? ball_y_reg + ball_y_delta_next:
					ball_y_reg;
//new ball velocity
always_comb 
begin
	hit = '0;
	miss = '0;
	ball_x_delta_next = ball_x_delta_reg;
	ball_y_delta_next = ball_y_delta_reg;
	if(graph_still)
	begin
		ball_x_delta_next = BALL_V_N;
		ball_y_delta_next = BALL_V_P;
	end
	else if(ball_y_t < 1)
		ball_y_delta_next = BALL_V_P;
	else if(ball_y_b > (MAX_Y-1))
		ball_y_delta_next = BALL_V_N;
	else if(ball_x_l <= WALL_X_R)
		ball_x_delta_next = BALL_V_P;
	else if(ball_x_r >= BAR_X_L && ball_x_r <= BAR_X_R &&
		ball_y_b >= bar_y_t && ball_y_t <= bar_y_b)
	begin
		hit = '1;
		ball_x_delta_next = BALL_V_N;
	end
	else if(ball_x_r < MAX_X)
		miss = '1;
end
//rgb multiplexing
always_comb begin
	if(graph_on)
		graph_rgb = 3'b000;
	else
	begin
		if(wall_on)
			graph_rgb = wall_rgb;
		else if(bar_on)
			graph_rgb = bar_rgb;
		else if(rd_ball_on)
			graph_rgb = ball_rgb;
		else
			graph_rgb = 3'b110;
	end
end
endmodule : pong_graph_subsystem