#!/usr/bin/env ruby
# coding: UTF-8

# install_nodejs.rb
# 
# install pre-built node.js files for Raspberry Pi
# from: http://nodejs.org/dist/
# 
# created on : 2013.07.19
# last update: 2013.07.19
# 
# by meinside@gmail.com

NODEJS_DIST_BASEURL = "http://nodejs.org/dist"
TEMPORARY_DIR = "/tmp"
INSTALLATION_DIR = "/opt"

def print_usage
  puts "* usage: #{__FILE__} [NODE_VERSION]"
  puts "* ex:    #{__FILE__}"
  puts "         #{__FILE__} v0.10.13"
end

def versions
  `curl "#{NODEJS_DIST_BASEURL}/"`.scan(/v\d+.\d+.\d+/).uniq
end

def latest_version
  return versions.sort_by{|x| v = x.scan(/\d+/).map(&:to_i); v[0] * 10000 + v[1] * 100 + v[2]}.last
end

def download(version)
  version ||= latest_version

  if versions.include? version
    puts "> will download node.js with version: #{version}"
    filename = "node-#{version}-linux-arm-pi.tar.gz"
    `wget "#{NODEJS_DIST_BASEURL}/#{version}/#{filename}" -P "#{TEMPORARY_DIR}"`

    node_dir = File.join(INSTALLATION_DIR, File.basename(filename, ".tar.gz"))
    puts "> will extract files to: #{node_dir}"
    `sudo mkdir -p "#{INSTALLATION_DIR}"`
    `sudo tar -xzvf "#{File.join(TEMPORARY_DIR, filename)}" -C "#{INSTALLATION_DIR}"`
    `sudo ln -sfn "#{node_dir}" "#{File.join(INSTALLATION_DIR, "node")}"`
  else
    puts "# no such version exists: #{version}"
  end
end

if __FILE__ == $0

  if ARGV.include?("-h") || ARGV.include?("--help")
    print_usage
  else
    download ARGV[0]
  end

end

