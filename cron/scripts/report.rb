#!/usr/bin/env ruby
# coding: UTF-8

# report.rb
# 
# status-report script for raspberry pi server
# 
# created on : 2012.05.31
# last update: 2014.02.10
# 
# by meinside@gmail.com

require_relative 'lib/job'

=begin

$ crontab -e

# add following:

# m h  dom mon dow   command
0 6 * * * bash -l -c "/home/USERNAME/cron/scripts/report.rb 'Daily status report of Raspberry Pi'"

# then it will run at 6 AM everyday.

=end

DEFAULT_MAIL_TITLE = 'Current status report of Raspberry Pi'

class Report < Job
  class ServerStatus
    LOGO_IMG_URL = 'http://www.raspberrypi.org/wp-content/uploads/2012/03/Raspi_Colour_R.png'
    LOGO_LINK_URL = 'http://raspberrypi.org/'

    def self.get_current_ip
      ['eth0', 'wlan0'].each{|interface|
        if `/sbin/ifconfig #{interface}` =~ /inet addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
          return $1.strip
        end
      }
      return nil
    end

    def self.get_current_storage
      return `df -h`
    end

    def self.get_current_memory
      return `free`
    end

    def self.get_uptime
      return `uptime`.strip
    end

    def self.get_uname
      return `uname -a`
    end

    def self.get_cpu_temperature
      temp = 0.0
      File.open('/sys/class/thermal/thermal_zone0/temp', 'r'){|file|
        temp = file.read.strip.to_f / 1000.0
      }
      return temp
    end

    def self.decorate(title, content)
      return "<p><b>* #{title}:</b><br/><pre>#{content}</pre></p><hr/>"
    end

    def self.html_summary
      content = []

      # server stats
      content << decorate('System', get_uname)
      content << decorate('Uptime', get_uptime)
      content << decorate('CPU Temperature', "%.1f °C" %[get_cpu_temperature])
      content << decorate('IP', get_current_ip)
      content << decorate('Free Storage', get_current_storage)
      content << decorate('Free Memory', get_current_memory)

      # email footer
      content << "<p><a href='#{LOGO_LINK_URL}'><img src='#{LOGO_IMG_URL}' width='50px' alt='Logo'/></a>&nbsp;<i>This email was sent at #{Time.now.strftime("%Y-%m-%d %H:%M")}, using: #{__FILE__}</i></p>"

      return content.join('')
    end
  end

end

if __FILE__ == $0

  email_title = ARGV.count > 0 ? ARGV.join(' ') : DEFAULT_MAIL_TITLE

  Report.new{|job|
    # send daily-status-report email
    job.send_gmail(email_title, Report::ServerStatus.html_summary)
  }

end

