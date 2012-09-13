#!/usr/bin/env ruby
# coding: UTF-8

# led.rb
#
# show status of raspberry pi server with LEDs,
# using a typical RGB LED and
# Adafruit's 8x8 LED matrix (http://adafruit.com/products/959)
#
# * prerequisite: http://www.skpang.co.uk/blog/archives/575
# 
# created on : 2012.08.21
# last update: 2012.09.12
# 
# by meinside@gmail.com

$: << File.expand_path(File.join(File.dirname(__FILE__), "..", "ruby", "libs"))

require "rubygems"

require "my_gpio"

# need 'i2c' gem installed
require "i2c/i2c.rb"
require "i2c/backends/i2c-dev.rb"

=begin

#!/bin/bash

# sample cron script

. /etc/profile.d/rvm.sh
SHELL=/usr/local/bin/rvm-shell

RUBY=/usr/local/rvm/rubies/ruby-1.9.3-p194/bin/ruby
SCRIPT=/home/meinside/bin/led.rb

$RUBY $SCRIPT

=end

LED_RGB_SYMBOLS = {
  red: :red,
  green: :green,
  blue: :blue,
  purple: :purple,
  yellow: :yellow,
  cyan: :cyan,
  white: :white,
  on: :white,
  black: :black,
  off: :black,
}

class RGBLED

	GPIO_PIN_LED_R = 23	# GPIO #23
	GPIO_PIN_LED_G = 24	# GPIO #24
	GPIO_PIN_LED_B = 25	# GPIO #25

	def initialize
		@gpio = MyGPIO.new(WPI_MODE_GPIO){|gpio|
			gpio.mode(GPIO_PIN_LED_R, OUTPUT)
			gpio.mode(GPIO_PIN_LED_G, OUTPUT)
			gpio.mode(GPIO_PIN_LED_B, OUTPUT)
		}

		if block_given?
			yield self
		end
	end

	def led_rgb(r = true, g =  true, b = true)
		@gpio.write(GPIO_PIN_LED_R, r ? LOW : HIGH)
		@gpio.write(GPIO_PIN_LED_G, g ? LOW : HIGH)
		@gpio.write(GPIO_PIN_LED_B, b ? LOW : HIGH)
	end

	def change_color_to(color)
		case color
		when :red
			led_rgb(true, false, false)
		when :green
			led_rgb(false, true, false)
		when :blue
			led_rgb(false, false, true)
		when :purple
			led_rgb(true, false, true)
		when :yellow
			led_rgb(true, true, false)
		when :cyan
			led_rgb(false, true, true)
		when :white || :on
			led_rgb(true, true, true)
		when :black || :off
			led_rgb(false, false, false)
		else
			puts "# no such color code: #{color.to_s}"
		end
	end

end

LED8X8_BRIGHTNESS = 1
  
LED_8X8_SYMBOLS = {
  smile: [
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [1, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 1, 0, 0, 1, 0, 1],
    [1, 1, 0, 0, 0, 0, 1, 1],
    [1, 0, 1, 1, 1, 1, 0, 1],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
  ],
  skull: [
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [1, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [0, 1, 0, 1, 1, 0, 1, 0],
    [0, 1, 1, 0, 0, 1, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
  ],
  o: [
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
  ],
  x: [
    [1, 0, 0, 0, 0, 0, 0, 1],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [0, 0, 1, 0, 0, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 1, 0, 0, 1, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 0],
    [1, 0, 0, 0, 0, 0, 0, 1],
  ],
  question: [
    [0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 0, 0, 1, 1, 0],
    [0, 0, 0, 0, 0, 1, 1, 0],
    [0, 0, 0, 1, 1, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
  ],
  fuck: [
    [1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 1],
    [1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 0, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1, 0, 1, 0],
    [1, 1, 1, 1, 1, 0, 0, 1],
  ],
  good: [
    [1, 1, 1, 1, 0, 1, 1, 0],
    [1, 0, 0, 0, 1, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 0, 1],
    [1, 1, 1, 1, 0, 1, 1, 0],
    [0, 1, 1, 0, 1, 1, 1, 0],
    [1, 0, 0, 1, 1, 0, 0, 1],
    [1, 0, 0, 1, 1, 0, 0, 1],
    [0, 1, 1, 0, 1, 1, 1, 0],
  ],
  blank: [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ],
}

# referenced: 
#   https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/blob/master/Adafruit_LEDBackpack/Adafruit_LEDBackpack.py
class AdafruitLED8x8Matrix

  # Registers
  HT16K33_REGISTER_DISPLAY_SETUP        = 0x80
  HT16K33_REGISTER_SYSTEM_SETUP         = 0x20
  HT16K33_REGISTER_DIMMING              = 0xE0

  # Blink rate
  HT16K33_BLINKRATE_OFF                 = 0x00
  HT16K33_BLINKRATE_2HZ                 = 0x01
  HT16K33_BLINKRATE_1HZ                 = 0x02
  HT16K33_BLINKRATE_HALFHZ              = 0x03

  MAX_COL = 8
  MAX_ROW = 8

  def initialize(device = "/dev/i2c-0", address = 0x70, options = {blink_rate: HT16K33_BLINKRATE_OFF, brightness: 15})
    if device.kind_of? String
      @device = ::I2C.create(device)
    else
      [ :read, :write ].each do |m|
        raise IncompatibleDeviceException, 
        "Missing #{m} method in device object." unless device.respond_to?(m)
      end
      @device = device
    end
    @address = address

    # turn on oscillator
    @device.write(@address, HT16K33_REGISTER_SYSTEM_SETUP | 0x01, 0x00)

    # set blink rate and brightness
    set_blink_rate(options[:blink_rate])
    set_brightness(options[:brightness])

    if block_given?
      yield self
    end
  end

  def set_blink_rate(rate)
    rate = HT16K33_BLINKRATE_OFF if rate > HT16K33_BLINKRATE_HALFHZ
    @device.write(@address, HT16K33_REGISTER_DISPLAY_SETUP | 0x01 | (rate << 1), 0x00)
  end

  def set_brightness(brightness)
    brightness = 15 if brightness > 15
    @device.write(@address, HT16K33_REGISTER_DIMMING | brightness, 0x00)
  end

  def clear
    (0...MAX_ROW).each{|n| write(n, 0x00)}
  end

  def fill
    (0...MAX_ROW).each{|n| write(n, 0xFF)}
  end

  def write(row, value)
    value = (value << MAX_COL - 1) | (value >> 1)
    @device.write(@address, row * 2, value & 0xFF)
    @device.write(@address, row * 2 + 1, value >> MAX_COL)
  end

  def write_array(arr)
    raise "given array has wrong number of elements: #{arr.count}" if arr.count != MAX_ROW

    arr.each_with_index{|e, i|
      if e.kind_of? Array
        raise "row #{i} has wrong number of elements: #{e.count}" if e.count != MAX_COL

        # XXX - reverse horizontally
        e = e.reverse.map{|x| (x.to_i > 0 || x =~ /o/i) ? 1 : 0}.inject(0){|x, y| (x << 1) + y}
      end
      write(i, e.to_i)
    }
  end

  def read(row)
    @device.read(@address, 2, row * 2).unpack("C")[0]
  end

end

def show_usage
  puts <<USAGE
* usage:
  $ rvmsudo #{__FILE__} [command [argument]]

* available commands and arguments:
  > help
  > rgb [#{LED_RGB_SYMBOLS.keys.join(" | ")}]
  > 8x8 [#{LED_8X8_SYMBOLS.keys.join(" | ")}]
  > test
USAGE
end

def exec_command(cmd, arg)

  case cmd
  when /help/i
    show_usage
  when /rgb/i
    if LED_RGB_SYMBOLS.has_key? arg.to_sym
      RGBLED.new{|led|
        led.change_color_to(arg.to_sym)
      }
    else
      puts "* no matching argument: #{arg}"
    end
  when /8x8/i
    if LED_8X8_SYMBOLS.has_key? arg.to_sym
      AdafruitLED8x8Matrix.new("/dev/i2c-0", 0x70, {brightness: LED8X8_BRIGHTNESS, blink_rate: AdafruitLED8x8Matrix::HT16K33_BLINKRATE_HALFHZ}){|led|
        led.clear
        led.write_array LED_8X8_SYMBOLS[arg.to_sym]
      }
    else
      puts "* no matching argument: #{arg}"
    end
  when /test/i
    RGBLED.new{|led|
      LED_RGB_SYMBOLS.keys.each{|k|
        led.change_color_to LED_RGB_SYMBOLS[k]
        sleep 1
      }
    }
    AdafruitLED8x8Matrix.new{|led|
      LED_8X8_SYMBOLS.keys.each{|k|
        led.clear
        led.write_array LED_8X8_SYMBOLS[k]
        sleep 1
      }
    }
  else
    puts "* no matching command: #{cmd}"
  end

end

if __FILE__ == $0

  if ARGV.count <= 0
    show_usage
  else
    cmd = ARGV[0]
    arg = ARGV[1..-1].join(" ").strip
    exec_command(cmd, arg)
  end

end

