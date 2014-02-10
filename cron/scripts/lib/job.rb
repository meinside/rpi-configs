#!/usr/bin/env ruby
# coding: UTF-8

# cron/scripts/lib/job.rb
# 
# base class for cron jobs
# 
# created on : 2012.09.03
# last update: 2014.02.10
# 
# by meinside@gmail.com

require 'yaml'

# using: https://github.com/meinside/meinside-ruby
require 'bundler/setup'
require 'my_gmail'

class Job
  CONFIG_FILEPATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '.conf', 'configs.yml'))

  @configs = nil

  def initialize
    @configs = read_configs

    if block_given?
      yield self
    end
  end

  def read_configs
    if File.exists? CONFIG_FILEPATH
      File.open(CONFIG_FILEPATH, 'r'){|file|
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

  def send_gmail(title, html_content)
    configs = @configs['email']['notification']
    MyGmail.send({
      username: configs['sender']['username'],
      passwd: configs['sender']['passwd'],
      recipient: configs['recipient']['email'],
      title: title,
      html_content: html_content,
    })
  end

end

