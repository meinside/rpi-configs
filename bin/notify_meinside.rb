#!/usr/bin/env ruby
# coding: UTF-8

# notify_meinside.rb
# 
# notify me about current status of raspberry pi
# 
# created on : 2012.05.31
# last update: 2012.06.02
# 
# by meinside@gmail.com

require "rubygems"
require "gmail"	# gem install mime ruby-gmail (https://github.com/dcparker/ruby-gmail)
require "yaml"

CONFIG_FILEPATH = File.join(File.dirname(__FILE__), "configs.yml")

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

def send_gmail(configs, title, content)
	Gmail.new(configs["gmail_sender"]["username"], configs["gmail_sender"]["passwd"]) {|gmail|
		gmail.deliver {
			to configs["notification_recipient"]["email"]
			subject title
			text_part {
				body content
			}
		}
	}
end

def get_current_ip
	if `ifconfig eth0` =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
		return $1.strip
	end
	return nil
end

def get_current_storage
	return `df -h`.strip
end

def get_current_memory
	return `free`.strip
end

def get_uptime
	return `uptime`.strip
end

def get_uname
	return `uname -a`.strip
end

if __FILE__ == $0

	current_ip = get_current_ip
	if current_ip
		content = []

		# uname
		content << "* System: \n#{get_uname}"

		# uptime
		content << "* Uptime: \n#{get_uptime}"

		# ip
		content << "* IP: #{current_ip}" if current_ip

		# storage
		content << "* Free Storage: \n#{get_current_storage}"

		# memory
		content << "* Free memory: \n#{get_current_memory}"
		
		content << "\n\n"
		content << "This email was sent at #{Time.now.strftime("%Y-%m-%d %H:%M")}, using: #{__FILE__}\n\n"

		# send result
		send_gmail(read_configs, "Current Status of Raspberry Pi", content.join("\n----\n")) if current_ip
	end

end

