`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:38 06/01/2015 
// Design Name: 
// Module Name:    watch 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module watch(
    input up_i,
    input down_i,
	input left_i,
	input right_i,
    input enter_i,
    input esc_i,
    input clk,
    output [7:0] o5,
    output [7:0] o4,
    output [7:0] o3,
    output [7:0] o2,
    output [7:0] o1,
    output [7:0] o0,
	output alarm
    );

	wire up, down, enter, esc;
	assign up = ~up_i;
	assign down = ~down_i;
	assign left = ~left_i;
	assign right = ~right_i;
	assign enter = ~enter_i;
	assign esc = ~esc_i;
	
	reg [7:0] out5, out4, out3, out2, out1, out0;
	assign o5 = out5; assign o4 = out4; assign o3 = out3;
	assign o2 = out2; assign o1 = out1; assign o0 = out0;
	
	reg [4:0] bcd5, bcd4, bcd3, bcd2, bcd1, bcd0;
	wire [7:0] seven5, seven4, seven3, seven2, seven1, seven0;
	reg [5:0] blink_in, blink, blink_out;
	reg [7:0] blink_out5, blink_out4, blink_out3, blink_out2, blink_out1, blink_out0;
	reg [15:0] count_blink;

	reg [7:0] date_out5, date_out4, date_out3, date_out2, date_out1, date_out0;
	reg [7:0] watch_out5, watch_out4, watch_out3, watch_out2, watch_out1, watch_out0;
	reg [7:0] alarm_out5, alarm_out4, alarm_out3, alarm_out2, alarm_out1, alarm_out0;
	reg [7:0] sw_out5, sw_out4, sw_out3, sw_out2, sw_out1, sw_out0;
	reg [7:0] timer_out5, timer_out4, timer_out3, timer_out2, timer_out1, timer_out0;
	reg [7:0] dday_out5, dday_out4, dday_out3, dday_out2, dday_out1, dday_out0;
	reg [7:0] ladder_out5, ladder_out4, ladder_out3, ladder_out2, ladder_out1, ladder_out0;
	reg [3:0] mode;
	
	// Blink signal
	always @(posedge clk) begin 
		count_blink = count_blink + 1;
		if (count_blink == 500000) begin
			count_blink = 0;
			blink = ~blink; 
			blink_out = ~blink_in | (blink_in & blink);
		end
		if (blink_out[0]) blink_out0 = 8'b11111111;
		else blink_out0 = 0;
		if (blink_out[1]) blink_out1 = 8'b11111111;
		else blink_out1 = 0;
		if (blink_out[2]) blink_out2 = 8'b11111111;
		else blink_out2 = 0;
		if (blink_out[3]) blink_out3 = 8'b11111111;
		else blink_out3 = 0;
		if (blink_out[4]) blink_out4 = 8'b11111111;
		else blink_out4 = 0;
		if (blink_out[5]) blink_out5 = 8'b11111111;
		else blink_out5 = 0;
	end
	
	bcd2seven decoder5(.in(bcd5), .out(seven5));
	bcd2seven decoder4(.in(bcd4), .out(seven4));
	bcd2seven decoder3(.in(bcd3), .out(seven3));
	bcd2seven decoder2(.in(bcd2), .out(seven2));
	bcd2seven decoder1(.in(bcd1), .out(seven1));
	bcd2seven decoder0(.in(bcd0), .out(seven0));

	initial begin
		mode = 1;
		count_blink = 0;
		blink_in = 0;
		blink_out = 0;
		blink = 0;
		blink_out5 = 0;
		blink_out4 = 0;
		blink_out3 = 0;
		blink_out2 = 0;
		blink_out1 = 0;
		blink_out0 = 0;
	end
	
	// Mode
	always @(mode) begin
		blink_in = 0;
		case(mode)
			0: begin
				bcd5 <= date_out5;
				bcd4 <= date_out4;
				bcd3 <= date_out3;
				bcd2 <= date_out2;
				bcd1 <= date_out1;
				bcd0 <= date_out0;
			end
			1: begin
				bcd5 <= watch_out5;
				bcd4 <= watch_out4;
				bcd3 <= watch_out3;
				bcd2 <= watch_out2;
				bcd1 <= watch_out1;
				bcd0 <= watch_out0;
			end
			2: begin
				bcd5 <= alarm_out5;
				bcd4 <= alarm_out4;
				bcd3 <= alarm_out3;
				bcd2 <= alarm_out2;
				bcd1 <= alarm_out1;
				bcd0 <= alarm_out0;
			end
			3: begin
				bcd5 <= sw_out5;
				bcd4 <= sw_out4;
				bcd3 <= sw_out3;
				bcd2 <= sw_out2;
				bcd1 <= sw_out1;
				bcd0 <= sw_out0;
			end
			4: begin
				bcd5 <= timer_out5;
				bcd4 <= timer_out4;
				bcd3 <= timer_out3;
				bcd2 <= timer_out2;
				bcd1 <= timer_out1;
				bcd0 <= timer_out0;
			end
		endcase
		
		case(mode)
			0, 1, 2, 3, 4: begin
				out5 <= seven5 & blink_out5;
				out4 <= seven4 & blink_out4;
				out3 <= seven3 & blink_out3;
				out2 <= seven2 & blink_out2;
				out1 <= seven1 & blink_out1;
				out0 <= seven0 & blink_out0;
			end
			5: begin
				out5 <= dday_out5 & blink_out5;
				out4 <= dday_out4 & blink_out4;
				out3 <= dday_out3 & blink_out3;
				out2 <= dday_out2 & blink_out2;
				out1 <= dday_out1 & blink_out1;
				out0 <= dday_out0 & blink_out0;
			end
			6: begin
				out5 <= ladder_out5 & blink_out5;
				out4 <= ladder_out4 & blink_out4;
				out3 <= ladder_out3 & blink_out3;
				out2 <= ladder_out2 & blink_out2;
				out1 <= ladder_out1 & blink_out1;
				out0 <= ladder_out0 & blink_out0;
			end
		endcase
	end
	

	/******* Watch(1) & date(0) *******/
	reg [19:0] count;
	reg [6:0] year; wire [6:0] year_w;
	reg [3:0] year1, year0;	wire [3:0] year1_w, year0_w;
	reg [3:0] month; wire [3:0] month_w;
	reg [3:0] month1, month0; wire [3:0] month1_w, month0_w;
	reg [4:0] day;	wire [4:0] day_w;
	reg [3:0] day1, day0; wire [3:0] day1_w, day0_w;
	reg [4:0] hour; wire [4:0] hour_w;
	reg [3:0] hour1, hour0;	wire [3:0] hour1_w, hour0_w;
	reg [5:0] min;	wire [5:0] min_w;
	reg [3:0] min1, min0; wire [3:0] min1_w, min0_w;
	reg [5:0] sec;	wire [5:0] sec_w;
	reg [3:0] sec1, sec0; wire [3:0] sec1_w, sec0_w;
	reg month_c, day_c, hour_c, min_c, sec_c;
	reg [4:0] day_num; wire [4:0] day_num_w;
	reg date_setting, watch_setting;
	assign year_w = year, year1_w = year1, year0_w = year0;
	assign month_w= month, month1_w = month1, month0_w = month0;
	assign day_w= day, day1_w = day1, day0_w = day0;
	assign hour_w= hour, hour1_w = hour1, hour0_w = hour0;
	assign min_w= min, min1_w = min1, min0_w = min0;
	assign sec_w= sec, sec1_w = sec1, sec0_w = sec0;
	assign day_num_w = day_num;
	
	// Enter
	always @(posedge enter) begin
		if (mode == 0) date_setting = 1;
		else if (mode == 1) watch_setting = 1;
	end
	
	// Esc
	always @(posedge esc) begin
		if (mode == 0) date_setting = 0;
		else if (mode == 1) watch_setting = 0;
	end

	// Left
	always @(posedge left) begin
		if (mode == 0 || mode == 1) begin
			blink_in[0] <= blink_in[2];
			blink_in[1] <= blink_in[3];
			blink_in[2] <= blink_in[4];
			blink_in[3] <= blink_in[5];
			blink_in[4] <= blink_in[0];
			blink_in[5] <= blink_in[1];
		end
	end
	
	// Right
	always @(posedge right) begin
		if (mode == 0 || mode == 1) begin
			blink_in[0] <= blink_in[4];
			blink_in[1] <= blink_in[5];
			blink_in[2] <= blink_in[0];
			blink_in[3] <= blink_in[1];
			blink_in[4] <= blink_in[2];
			blink_in[5] <= blink_in[3];
		end
	end
	
	// Up
	always @(posedge up) begin
		if (mode == 0 && date_setting == 1) begin
			case (blink_in)
				6'b000011: begin
					if (day == day_num) day = 1;
					else day = day + 1;
				end
				6'b001100: begin
					if (month == 12) month = 1;
					else month = month + 1;
					if (day > day_num) day = day_num;
				end
				6'b110000: begin
					if (year == 99) year = 0;
					else year = year + 1;
					if (day > day_num) day = day_num;
				end
			endcase
		end
		else if (mode == 1 && watch_setting == 1) begin
			case (blink_in)
				6'b000011: begin
					if (sec == 59) sec = 0;
					else sec = sec + 1;
				end
				6'b001100: begin
					if (min == 59) min = 0;
					else min = min + 1;
				end
				6'b110000: begin
					if (hour == 23) hour = 0;
					else hour = hour + 1;
				end
			endcase
		end
		else if (mode == 0 && date_setting == 0) mode = 1;
		else if (mode == 1 && watch_setting == 0) mode = 2;
	end
	
	// Down
	always @(posedge down) begin
		if (mode == 0 && date_setting == 1) begin
			case (blink_in)
				6'b000011: begin
					if (day == 1) day = day_num;
					else day = day - 1;
				end
				6'b001100: begin
					if (month == 1) month = 12;
					else month = month - 1;
					if (day > day_num) day = day_num;
				end
				6'b110000: begin
					if (year == 0) year = 99;
					else year = year - 1;
					if (day > day_num) day = day_num;
				end
			endcase
		end
		else if (mode == 1 && watch_setting == 1) begin
			case (blink_in)
				6'b000011: begin
					if (sec == 0) sec = 59;
					else sec = sec - 1;
				end
				6'b001100: begin
					if (min == 0) min = 59;
					else min = min - 1;
				end
				6'b110000: begin
					if (hour == 0) hour = 23;
					else hour = hour - 1;
				end
			endcase
		end
		else if (mode == 0 && date_setting == 0) mode = 6;
		else if (mode == 1 && watch_setting == 0) mode = 1;
	end
	
	// Initialization
	initial begin
		count = 0;
		year = 15; month = 1; day = 1; hour = 0; min = 0; sec = 0;
		sec_c = 0; min_c = 0; hour_c = 0; day_c = 0; month_c = 0;
	end
	
	// Ripple carry increment
	always @(posedge clk) begin
		count = count + 1;
		if (count == 1000000) begin
			count = 0;
			sec = sec + 1;
			if (sec == 60) begin
				sec = 0;
				sec_c = 1;
			end
		end
		if (sec_c) sec_c = 0;
		if (min_c) min_c = 0;
		if (hour_c) hour_c = 0;
		if (day_c) day_c = 0;
		if (month_c) month_c = 0;
	end
	always @(posedge sec_c) begin
		min = min + 1;
		//sec_c = 0;
		if (min == 60) begin
			min = 0;
			min_c = 1;
		end
	end
	always @(posedge min_c) begin
		hour = hour + 1;
		//min_c = 0;
		if (hour == 24) begin
			hour = 0;
			hour_c = 1;
		end
	end
	always @(posedge hour_c) begin
		day = day + 1;
		//hour_c = 0;
		if (day == day_num + 1) begin
			day = 1;
			day_c = 1;
		end
	end
	always @(posedge day_c) begin
		month = month + 1;
		//day_c = 0;
		if (month == 13) begin
			month = 1;
			month_c = 1;
		end
	end
	always @(posedge month_c) begin
		year = year + 1;
		//month_c = 0;
		if (year == 100) begin
			year = 0;
		end
	end

	
	always @(date_setting) begin
		if (mode == 0 && date_setting == 1) blink_in = 6'b110000;
		else blink_in = 6'b000000;
	end
	
	always @(watch_setting) begin
		if (mode == 1 && watch_setting == 1) blink_in = 6'b110000;
		else blink_in = 6'b000000;
	end
		
	day_of_month present(.year(year), .month(month), .num(day_num_w));
	
	digit_split hour_split(.in(hour), .out1(hour1_w), .out0(hour0_w));
	digit_split day_split(.in(day), .out1(day1_w), .out0(day0_w));
	digit_split year_split(.in(year), .out1(year1_w), .out0(year0_w));
	
	
	/******* Alarm(2) *******/
	
	// Up
	always @(posedge up) begin
		if (mode == 2) mode = mode + 1;
	end
	
	// Down
	always @(posedge down) begin
		if (mode == 2) mode = mode - 1;
	end	
	/******* Stopwatch(3) *******/
	
	// Up
	always @(posedge up) begin
		if (mode == 3) mode = mode + 1;
	end
	
	// Down
	always @(posedge down) begin
		if (mode == 3) mode = mode - 1;
	end	
	
	/******* Timer(4) *******/
		
	// Up
	always @(posedge up) begin
		if (mode == 4) mode = mode + 1;
	end
	
	// Down
	always @(posedge down) begin
		if (mode == 4) mode = mode - 1;
	end	

	/******* D-day(5) *******/
		
	// Up
	always @(posedge up) begin
		if (mode == 5) mode = mode + 1;
	end
	
	// Down
	always @(posedge down) begin
		if (mode == 5) mode = mode - 1;
	end	

	/******* Ladder game(6) *******/
	
	// Up
	always @(posedge up) begin
		if (mode == 6) mode = 0;
	end
	
	// Down
	always @(posedge down) begin
		if (mode == 6) mode = mode - 1;
	end	
	
endmodule

module day_of_month(year,month,num);
	input year,month;
	output num;
	reg [4:0] num;
	
	always @(year or month) begin
		case(month)
			1, 3, 5, 7, 8, 10, 12: num = 31;
			4, 6, 9, 11: num = 30;
			2: begin
				if(year & 3 == 0) num = 29;
				else num = 28;
			end
		endcase
	end
endmodule

module bcd2seven(
    input [4:0] in,
    output [7:0] out
    );
    
	assign out[7] = in[4];
    assign out[6] = in[3] | ~(in[0]^in[2]) | (in[1] & ~in[2]);
    assign out[5] = ~in[2] | ~(in[1]^in[0]);
    assign out[4] = in[2] | (~in[1]) | in[0];
    assign out[3] = ~in[2] & ~in[0] | (in[2]^in[0])^~in[1] | (in[2]^in[0]) & in[1];
    assign out[2] = (~in[2] | in[1]) & ~in[0];
    assign out[1] = in[3] | (in[2] & ~in[0]) | ~(in[0] | in[1]) | (~in[1] & in[2]);
    assign out[0] = in[3] | (in[2]^in[1]) | in[1] & ~in[0];
    
endmodule

module digit_split(
	input [6:0] in,
	output [3:0] out1, out0
	);
	
	reg [3:0] d1, d0;
	assign out1 = d1, out0 = d0;
	
	always @(in) begin
		if (in >= 90) begin d1 = 9; d0 = in - 90; end
		else if (in >= 80) begin d1 = 8; d0 = in - 80; end
		else if (in >= 70) begin d1 = 7; d0 = in - 70; end
		else if (in >= 60) begin d1 = 6; d0 = in - 60; end
		else if (in >= 50) begin d1 = 5; d0 = in - 50; end
		else if (in >= 40) begin d1 = 4; d0 = in - 40; end
		else if (in >= 30) begin d1 = 3; d0 = in - 30; end
		else if (in >= 20) begin d1 = 2; d0 = in - 20; end
		else if (in >= 10) begin d1 = 1; d0 = in - 10; end
		else begin d1 = 0; d0 = in; end
	end
endmodule
