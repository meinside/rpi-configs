#!/usr/bin/env ruby
# coding: UTF-8

# hourly.rb
#
# daily-run script for raspberry pi server
# 
# created on : 2012.08.21
# last update: 2012.08.30
# 
# by meinside@gmail.com

require "wiringpi"	# gem install wiringpi

CRON_SCRIPT_EXAMPLE = <<CRON_SCRIPT
#!/bin/bash

. /etc/profile.d/rvm.sh
SHELL=/usr/local/bin/rvm-shell

RUBY=/usr/local/rvm/rubies/ruby-1.9.3-p194/bin/ruby
SCRIPT=/home/meinside/bin/jobs/hourly.rb

$RUBY $SCRIPT
CRON_SCRIPT

class HourlyJob

	GPIO_PIN_LED_R = 23	# GPIO #23
	GPIO_PIN_LED_G = 24	# GPIO #24
	GPIO_PIN_LED_B = 25	# GPIO #25

	RUN_CYCLE_SECONDS = 0.1

	def initialize
		@io = WiringPi::GPIO.new(WPI_MODE_GPIO)

		@io.mode(GPIO_PIN_LED_R, OUTPUT)
		@io.mode(GPIO_PIN_LED_G, OUTPUT)
		@io.mode(GPIO_PIN_LED_B, OUTPUT)

		if block_given?
			yield self
		end
	end

	def led_rgb(r = true, g =  true, b = true)
		@io.write(GPIO_PIN_LED_R, r ? LOW : HIGH)
		@io.write(GPIO_PIN_LED_G, g ? LOW : HIGH)
		@io.write(GPIO_PIN_LED_B, b ? LOW : HIGH)
	end

	def change_led_color(color)
		case color
		when :red
			led_rgb(true, false, false)
		when :green
			led_rgb(false, true, false)
		when :blue
			led_rgb(false, false, true)
		when :purple
			led_rgb(true, false, false)
		when :yellow
			led_rgb(true, true, false)
		when :cyan
			led_rgb(false, true, true)
		when :white
			led_rgb(true, true, true)
		when :black || :off
			led_rgb(false, false, false)
		else
			puts "# no such color code: #{color.to_s}"
		end
	end

end

if __FILE__ == $0

	color_seqs = [:red, :green, :blue, :purple, :yellow, :cyan]

	HourlyJob.new{|job|
		# change led's color hourly
		job.change_led_color(color_seqs[Time.now.hour % color_seqs.size])
	}

end

