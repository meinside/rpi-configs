#!/usr/bin/env ruby
# coding: UTF-8

# install_go.rb
# 
# install pre-built node.js files for Raspberry Pi
# from: http://nodejs.org/dist/
# 
# created on : 2014.06.18
# last update: 2014.06.18
# 
# by meinside@gmail.com

# thanks to: http://dave.cheney.net/unofficial-arm-tarballs
TARBALL_URL = 'http://dave.cheney.net/paste/go1.2.2.linux-arm~multiarch-armv6-1.tar.gz'
TEMPORARY_DIR = '/tmp'
INSTALLATION_DIR = '/opt'

def download
  puts "> will download tarball from: #{TARBALL_URL}"
  `wget "#{TARBALL_URL}" -P "#{TEMPORARY_DIR}"`

  filename = File.basename(TARBALL_URL)
  go_dir = File.join(INSTALLATION_DIR, File.basename(filename, '.tar.gz'))
  puts "> will extract files to: #{go_dir}"
  `sudo mkdir -p "#{INSTALLATION_DIR}"`
  `sudo tar -xzvf "#{File.join(TEMPORARY_DIR, filename)}" -C "#{INSTALLATION_DIR}"`
  `sudo mv "#{File.join(INSTALLATION_DIR, 'go')}" "#{go_dir}"`
  `sudo chown -R $USER "#{go_dir}"`
  `sudo ln -sfn "#{go_dir}" "#{File.join(INSTALLATION_DIR, 'go')}"`
end

if __FILE__ == $0
  download
end

