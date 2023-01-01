`timescale 1ns / 1ns
`default_nettype wire

//    This file is part of the ZXUNO Spectrum core. 
//    Creation date is 02:28:18 2014-02-06 by Miguel Angel Rodriguez Jodar
//    (c)2014-2020 ZXUNO association.
//    ZXUNO official repository: http://svn.zxuno.com/svn/zxuno
//    Username: guest   Password: zxuno
//    Github repository for this core: https://github.com/mcleod-ideafix/zxuno_spectrum_core
//
//    ZXUNO Spectrum core is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    ZXUNO Spectrum core is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//e
//    You should have received a copy of the GNU General Public License
//    along with the ZXUNO Spectrum core.  If not, see <https://www.gnu.org/licenses/>.
//
//    Any distributed copy of this file must keep this notice intact.

//Max
//UnoXT Generation Selector
`define unoxt
//`define unoxt2

`ifdef unoxt
	module unoxt_top (
`elsif unoxt2
	module unoxt2_top (
`else
	module unoxt_top (
`endif

   input wire clock_50_i,
	
   output wire [4:0] rgb_r_o,
   output wire [4:0] rgb_g_o,
   output wire [4:0] rgb_b_o,
   output wire hsync_o,
   output wire vsync_o,
   input wire ear_port_i,
   output wire mic_port_o,
   inout wire ps2_clk_io,
   inout wire ps2_data_io,
   inout wire ps2_pin6_io,
   inout wire ps2_pin2_io,
   output wire audioext_l_o,
   output wire audioext_r_o,

   inout wire esp_gpio0_io,
   inout wire esp_gpio2_io,
	output wire esp_tx_o,
   input wire esp_rx_i,
 
   output wire [20:0] ram_addr_o,
	output wire ram_lb_n_o,
	output wire ram_ub_n_o,
   inout wire [15:0] ram_data_io,
   output wire ram_oe_n_o,
   output wire ram_we_n_o,
   output wire ram_ce_n_o,
   
   output wire flash_cs_n_o,
   output wire flash_sclk_o,
   output wire flash_mosi_o,
   input wire flash_miso_i,
	output wire flash_wp_o,
	output wire flash_hold_o,
   
   input wire joyp1_i,
   input wire joyp2_i,
   input wire joyp3_i,
   input wire joyp4_i,
   input wire joyp6_i,
   output wire joyp7_o,
   input wire joyp9_i,
	
   input wire btn_divmmc_n_i,
   input wire btn_multiface_n_i,

   output wire sd_cs0_n_o,    
   output wire sd_sclk_o,     
   output wire sd_mosi_o,    
   input wire sd_miso_i,

	output wire led_red_o,
	output wire led_yellow_o,
   output wire led_green_o,   // nos servir como testigo de uso de la SPI
	output wire led_blue_o

	//output wire [8:0] test

   );
   
   //Max
	`define DEFAULT_100_LEDS;
	
	`ifdef ROUND_DIF_LEDS
		//3mm round diffused LEDs
		localparam ledRedK = 16'd20;
		localparam ledYellowK = 16'd50;
		localparam ledGreenK = 16'd12;
		localparam ledBlueK = 16'd50;
	`elsif SQUARE_LEDS
		//square color LEDs
		localparam ledRedK = 16'd20;
		localparam ledYellowK = 16'd33;
		localparam ledGreenK = 16'd100;
		localparam ledBlueK = 16'd20;
	`else
		//default 100% LEDs
		localparam ledRedK = 16'd100;
		localparam ledYellowK = 16'd100;
		localparam ledGreenK = 16'd100;
		localparam ledBlueK = 16'd100;
	`endif
	
	wire sysclk;
	//Max
	wire greenLed;
	wire [1:0] turbo;
	wire [15:0] turbo100;
	wire [11:0] joyA;
	wire [7:0] joy1;
	wire [2:0] rgb_r, rgb_g, rgb_b;
	wire ram_ce_oe_n_o;
	wire [5:0] joystick;
	
	tld_sam_v4 sam(
		.clk50mhz(clock_50_i),
		.sysclk(sysclk),
		//.turbo(turbo),
		.ear(ear_port_i),
		.audio_out_left(audioext_l_o),
		.audio_out_right(audioext_r_o),
		.r(rgb_r),
		.g(rgb_g),
		.b(rgb_b),
		.hsync(hsync_o),
		.vsync(vsync_o),
		.stdn(),
		.stdnb(),
		
		.sram_addr(ram_addr_o),
		.sram_data(ram_data_io[7:0]),
		.sram_we_n(ram_we_n_o),
		
		.clkps2(ps2_clk_io),
		.dataps2(ps2_data_io),
		.mousedata(ps2_pin2_io),
		.mouseclk(ps2_pin6_io),
		
		.sd_cs_n(sd_cs0_n_o),
		.sd_clk(sd_sclk_o),
		.sd_mosi(sd_mosi_o),
		.sd_miso(sd_miso_i),
		
		.joyup(joyp1_i),
		.joydown(joyp2_i),
		.joyleft(joyp3_i),
		.joyright(joyp4_i),
		.joyfire(joyp6_i),
		
		.joyselect(),
		.led()

);
	
	//Max
	assign rgb_r_o = { rgb_r, rgb_r[2:1] };
	assign rgb_g_o = { rgb_g, rgb_g[2:1] };
	assign rgb_b_o = { rgb_b, rgb_b[2:1] };

 	assign joyp7_o = 1'b1;
	//assign joy1 = ~{ 3'b000, joyA[4], joyA[0], joyA[1], joyA[2], joyA[3]};
	
	assign ram_oe_n_o = 1'b0;
	assign ram_ce_n_o = 1'b0;
	assign ram_lb_n_o = 1'b0;
	assign ram_ub_n_o = 1'b1;
	assign ram_data_io[15:8] = 8'bz;
	//assign ram_addr_o[20:19] = 2'b00;
	
	assign mic_port_o = 1'b1;
 
	assign esp_gpio0_io = 1'b1;
   assign esp_gpio2_io = 1'b1;
	assign esp_tx_o = 1'b1;
	
	assign flash_cs_n_o = 1'b1;
	assign flash_sclk_o = 1'b1;
	assign flash_mosi_o = 1'b1;
	assign flash_wp_o = 1'b1;
	assign flash_hold_o = 1'b1;
	
	
	assign greenLed = !sd_cs0_n_o;
	/*flashCnt #(.CLK_MHZ(16'd21)) cnt(
		.clk(sysclk),
		.signal(sd_sclk_o),
		.msec(16'd20),
		.flash(greenLed)
	);*/
	
	/*assign turbo100 = (turbo == 2'b00) ? 16'd0 :
							(turbo == 2'b01) ? 16'd33 :
							(turbo == 2'b10) ? 16'd66 :
							(turbo == 2'b11) ? 16'd100 :
							16'd0;
	
	
  joystick #(.CLK_MHZ(16'd21)) joy 
  (
 		.clk(sysclk),
		.joyp1_i(joyp1_i),
		.joyp2_i(joyp2_i),
		.joyp3_i(joyp3_i),
		.joyp4_i(joyp4_i),
		.joyp6_i(joyp6_i),
		.joyp7_o(joyp7_o),
		.joyp9_i(joyp9_i),
		.joyOut(joyA)		// MXYZ SACB UDLR  1- On 0 - off
		//.test(test)
  );*/


 	ledPWM ledRed(
		.nReset(1'b1),
		.clock(sysclk),
		.enable(1'b1),
		.y1(16'd100),
		.y2(ledRedK),	
		.led(led_red_o)
    );

	//Max
	ledPWM ledYellow(
		.nReset(1'b1),
		.clock(sysclk),
		.enable(1'b1),
		.y1(turbo100),
		.y2(ledYellowK),	
		.led(led_yellow_o)
    );

	ledPWM ledGreen(
		.nReset(1'b1),
		.clock(sysclk),
		.enable(greenLed),
		.y1(16'd100),
		.y2(ledGreenK),	
		.led(led_green_o)
    );

	ledPWM ledBlue(
		.nReset(1'b1),
		.clock(sysclk),
		.enable(1'b0),
		.y1(16'd100),
		.y2(ledBlueK),	
		.led(led_blue_o)
    );
	 
	 /*assign test[0] = sd_cs0_n_o;
	 assign test[1] = sd_sclk_o;
	 assign test[2] = sd_mosi_o;
	 assign test[3] = sd_miso_i;
	 assign test[4] = 1'b1;
	 assign test[5] = test5;
	 assign test[6] = 1'b1;
	 assign test[7] = 1'b1;
	 assign test[8] = 1'b1;
	 */
  
endmodule
