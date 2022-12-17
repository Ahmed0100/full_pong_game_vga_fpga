module pong_text_subsystem
(
	input clk,
	input [1:0] balls_left_dig,
	input [3:0] score_dig_0,score_dig_1,
	input [9:0] pixel_x,pixel_y,
	output [3:0] text_on,
	output logic [2:0] text_rgb
);

//signal declaration
logic [10:0] rom_addr;
logic [6:0] char_addr,char_addr_logo,char_addr_score,
char_addr_rules,char_addr_game_over;

logic [3:0] row_addr,row_addr_logo,row_addr_score,
row_addr_rules,row_addr_game_over;

logic [2:0] bit_addr,bit_addr_logo,bit_addr_score,
bit_addr_rules,bit_addr_game_over;

logic [7:0] font_word;
logic font_bit,score_on,logo_on,rule_on,game_over_on;
logic [7:0] rom_rule_addr;

//font rom
font_rom font_rom_inst 
(.clk(clk), .addr(rom_addr), .data(font_word));

//score region
//display score and balls left
//scale to 16x32 font
//line 1. 16 chars: "Score :DD Ball:D"
assign score_on = ((pixel_y[9:5]==0) && (pixel_x[9:4]<16));
assign row_addr_score = pixel_y[4:1];
assign bit_addr_score = pixel_x[3:1];

always @*
begin
	case(pixel_x[7:4])
		4'h0: char_addr_score = 7'h53;
		4'h0: char_addr_score = 7'h53; // S 
		4'h1: char_addr_score = 7'h63; // c 
		4'h2: char_addr_score = 7'h6f; // o 
		4'h3: char_addr_score = 7'h72; // r 
		4'h4: char_addr_score = 7'h65; // e 
		4'h5: char_addr_score = 7'h3a; // : 
		4'h6: char_addr_score = {3'b011, score_dig_1}; // digit 10 
		4'h7: char_addr_score = {3'b011, score_dig_0}; // digit 1 
		4'h8: char_addr_score = 7'h00; // 
		4'h9: char_addr_score = 7'h00; // 
		4'ha: char_addr_score = 7'h42; // B 
		4'hb: char_addr_score = 7'h61; // a 
		4'hc: char_addr_score = 7'h6c; // 1 
		4'hd: char_addr_score = 7'h6c; // 1 
		4'he: char_addr_score = 7'h3a; // : 
		4'hf : char_addr_score = {5'b01100, balls_left_dig}; 
	endcase // pixel_x[7:4]
end
//logo region
//display logo "PONG" at center
//used as background
//scale to 64x128 font
assign logo_on = (pixel_y[9:7] == 2 &&
	(pixel_x[9:6]>=3 && pixel_x[9:6]<=6));
assign row_addr_logo = pixel_y[6:3];
assign bit_addr_logo = pixel_x[5:3];

always @*
begin
	case(pixel_x[8:6])
		3'h3: char_addr_logo = 7'h50;
		3'h4: char_addr_logo = 7'h4f;
		3'h5: char_addr_logo = 7'h4e;
		default: char_addr_logo = 7'h47;
	endcase
end
//rules region
//display rule (4x16 tiles) on center 
//test:
//Use two buttons
//to move paddle
//up and down
assign rule_on = (pixel_x[9:7] ==2 && pixel_y[9:6] ==2);
assign row_addr_rules = pixel_y[3:0];
assign bit_addr_rules = pixel_X[2:0];
assign rule_rom_addr = {pixel_y[5:4],pixel_x[6:3]};

always @*
begin
	case (rule-rom-addr) 
	// row 1 
	6'h00: char_addr_rules = 7'h52; // R 
	6'h01: char_addr_rules = 7'h55; // U 
	6'h02: char_addr_rules = 7'h4c; // L 
	6'h03: char_addr_rules = 7'h45; // E 
	6'h04: char_addr_rules = 7'h3a; // : 
	6'h05: char_addr_rules = 7'h00; // 
	6'h06: char_addr_rules = 7'h00;
	6'h07: char_addr_rules = 7'h00;
	6'h08: char_addr_rules = 7'h00;
	6'h09: char_addr_rules = 7'h00;
	6'h0a: char_addr_rules = 7'h00;
	6'h0b: char_addr_rules = 7'h00;
	6'h0c: char_addr_rules = 7'h00;
	6'h0d: char_addr_rules = 7'h00;
	6'h0e: char_addr_rules = 7'h00;
	6'h0f: char_addr_rules = 7'h00;
	// row 2
	6'h10: char_addr_rules = 7'h55; //
	6'h11: char_addr_rules = 7'h73; // s 
	6'h12: char_addr_rules = 7'h65; // e 
	6'h13: char_addr_rules = 7'h00; // 
	6'h14: char_addr_rules = 7'h74; // t 
	6'h15: char_addr_rules = 7'h77; // w 
	6'h16: char_addr_rules = 7'h6f; // o 
	6'h17: char_addr_rules = 7'h00; // 
	6'h18: char_addr_rules = 7'h62; // b 
	6'h19: char_addr_rules = 7'h75; // u 
	6'h1a: char_addr_rules = 7'h74; // t 
	6'h1b: char_addr_rules = 7'h74; // t 
	6'h1c: char_addr_rules = 7'h6f; // o 
	6'h1d: char_addr_rules = 7'h6e; // n 
	6'h1e: char_addr_rules = 7'h73; // s 
	6'h1f: char_addr_rules = 7'h00; // 
	//row 3
	6'h20: char_addr_rules = 7'h74; // t 
	6'h21: char_addr_rules = 7'h6f; // o 
	6'h22: char_addr_rules = 7'h00; // 
	6'h23: char_addr_rules = 7'h6d; // m 
	6'h24: char_addr_rules = 7'h6f; // o 
	6'h25: char_addr_rules = 7'h76; // v 
	6'h26: char_addr_rules = 7'h65; // e 
	6'h27: char_addr_rules = 7'h00; // 
	6'h28: char_addr_rules = 7'h70; // p 
	6'h29: char_addr_rules = 7'h61; // a 
	6'h2a: char_addr_rules = 7'h64; // d 
	6'h2b: char_addr_rules = 7'h64; // d 
	6'h2c: char_addr_rules = 7'h6c; // I 
	6'h2d: char_addr_rules = 7'h65; // e 
	6'h2e: char_addr_rules = 7'h00; // 
	//row 4
	6'h2f: char_addr_rules = 7'h00; // 
	6'h30: char_addr_rules = 7'h75; // u 
	6'h31: char_addr_rules = 7'h70; // p 
	6'h32: char_addr_rules = 7'h00; // 
	6'h33: char_addr_rules = 7'h61; // a 
	6'h34: char_addr_rules = 7'h6e; // n 
	6'h35: char_addr_rules = 7'h64; // d 
	6'h36: char_addr_rules = 7'h00; // 
	6'h37: char_addr_rules = 7'h64; // d 
	6'h38: char_addr_rules = 7'h6f; // o 
	6'h39: char_addr_rules = 7'h77; // w 
	6'h3a: char_addr_rules = 7'h6e; // n 
	6'h3b: char_addr_rules = 7'h2e; // . 
	6'h3c: char_addr_rules = 7'h00; // 
	6'h3d: char_addr_rules = 7'h00; // 
	6'h3e: char_addr_rules = 7'h00; // 
	6'h3f: char_addr_rules = 7'h00; // 
	endcase // rule-rom-addr
end
//game over region
//display "Game Over" at center
//scale to 32x64 font
assign game_over_on = (pixel_y[9:6]==3)&&
(pixel_x[9:5] >= 5) && (pixel_x[9:5]<=13);
assign row_addr_game_over = pixel_y[5:2];
assign bit_addr_game_over = pixel_y[4:2];
always @(*) 
begin
	case(pixel_x[8:5])
		4'h5: char_addr_game_over = 7'h47; // G 
		4'h6: char_addr_game_over = 7'h61; // a 
		4'h7: char_addr_game_over = 7'h6d; // m 
		4'h8: char_addr_game_over = 7'h65; // e 
		4'h9: char_addr_game_over = 7'h00; // 
		4'ha: char_addr_game_over = 7'h4f; // 0 
		4'hb: char_addr_game_over = 7'h76; // v 
		4'hc: char_addr_game_over = 7'h65; // e 
		default: char_addr_game_over = 7'h72; // r 
	endcase // pixel_x[8:5]
end
//mux for rom addr and text rgb
always @(*) 
begin
	text_rgb = 3'b110; //yellow bg
	if(score_on)
	begin
		char_addr = char_addr_score;
		row_addr = row_addr_score;
		bit_addr = bit_addr_score;
		if(font_bit)
			text_rgb = 3'b001;
	end
	else if(rule_on)
	begin
		char_addr = char_addr_rules;
		row_addr = row_addr_rules;
		bit_addr = bit_addr_rules;
		if(font_bit)
			text_rgb = 3'b001;
	end
	else if(logo_on)
	begin
		char_addr = char_addr_logo;
		row_addr = row_addr_logo;
		bit_addr = bit_addr_logo;
		if(font_bit)
			text_rgb = 3'b001;
	end
	else
	begin
		char_addr = char_addr_game_over;
		row_addr = row_addr_game_over;
		bit_addr = bit_addr_game_over;
		if(font_bit)
			text_rgb = 3'b001;
	end
end
assign text_on = {score_on,logo_on, rule_on,game_over_on};
//font rom interface
assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr];

endmodule