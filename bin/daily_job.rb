#!/usr/bin/env ruby
# coding: UTF-8

# daily_job.rb
# 
# daily-run script for raspberry pi server
# 
# created on : 2012.05.31
# last update: 2012.08.17
# 
# by meinside@gmail.com

require "rubygems"
require "gmail"	# gem install mime ruby-gmail (https://github.com/dcparker/ruby-gmail)
require "yaml"

CONFIG_FILEPATH = File.join(File.dirname(__FILE__), "configs.yml")

DEFAULT_MAIL_TITLE = "Current status report of Raspberry Pi"

CRON_SCRIPT_EXAMPLE = <<CRON_SCRIPT
#!/bin/bash

. /etc/profile.d/rvm.sh
SHELL=/usr/local/bin/rvm-shell

RUBY=/usr/local/rvm/rubies/ruby-1.9.3-p194/bin/ruby
SCRIPT=/home/meinside/bin/daily_job.rb

$RUBY $SCRIPT "Daily status report of Raspberry Pi"
CRON_SCRIPT

class DailyJob
	@configs = nil

	def initialize
		@configs = read_configs
		if block_given?
			yield self
		end
	end

	def read_configs
		if File.exists? CONFIG_FILEPATH
			File.open(CONFIG_FILEPATH, "r"){|file|
				begin
					return YAML.load(file)
				rescue
					puts "* error parsing config file: #{CONFIG_FILEPATH}"
				end
			}
		else
			puts "* config file not found: #{CONFIG_FILEPATH}"
		end
		return nil
	end

	def send_gmail(title, text_content, html_content)
		username = @configs["gmail_sender"]["username"]
		passwd = @configs["gmail_sender"]["passwd"]
		recipient = @configs["email_recipient"]["email"]

		Gmail.new(username, passwd) {|gmail|
			gmail.deliver {
				to recipient
				subject title
				if text_content
					text_part {
						body text_content
					}
				end
				if html_content
					html_part {
						content_type 'text/html; charset=UTF-8'
						body html_content
					}
				end
			}
		}
	end

	class ServerStatCheck

		LOGO_IMG_URL = "http://www.raspberrypi.org/wp-content/uploads/2012/03/Raspi_Colour_R.png"
		LOGO_LINK_URL = "http://raspberrypi.org/"

		def self.get_current_ip
			["eth0", "wlan0"].each{|interface|
				if `/sbin/ifconfig #{interface}` =~ /inet addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
					return $1.strip
				end
			}
			return nil
		end

		def self.get_current_storage
			return `df -h`.strip
		end

		def self.get_current_memory
			return `free`.strip
		end

		def self.get_uptime
			return `uptime`.strip
		end

		def self.get_uname
			return `uname -a`.strip
		end

		def self.decorate(title, content)
			return "<p><b>* #{title}:</b><br/><pre>#{content}</pre></p><hr/>"
		end

		def self.summary
			content = []

			# server stats
			content << decorate("System", get_uname)
			content << decorate("Uptime", get_uptime)
			content << decorate("IP", get_current_ip)
			content << decorate("Free Storage", get_current_storage)
			content << decorate("Free Memory", get_current_memory)

			# email footer
			content << "<p><a href='#{LOGO_LINK_URL}'><img src='#{LOGO_IMG_URL}' width='50px' alt='Logo'/></a>&nbsp;<i>This email was sent at #{Time.now.strftime("%Y-%m-%d %H:%M")}, using: #{__FILE__}</i></p>"

			return content.join("")
		end
	end

end

if __FILE__ == $0

	email_title = ARGV.count > 0 ? ARGV.join(" ") : DEFAULT_MAIL_TITLE

	DailyJob.new{|job|
		job.send_gmail(email_title, nil, DailyJob::ServerStatCheck.summary)
	}

end

