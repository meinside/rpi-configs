#!/usr/bin/env ruby
# coding: UTF-8

# install_phantomjs.rb
# 
# download, build, and install PhantomJS for Raspberry Pi
#
# * tested: PhantomJS 1.9.7 / Raspbian (Wheezy)
# 
# created on : 2014.02.13
# last update: 2014.02.15
# 
# by meinside@gmail.com

PHANTOMJS_REPOSITORY = 'git://github.com/ariya/phantomjs.git'
PHANTOMJS_BRANCH = '1.9'  # XXX

TEMPORARY_DIR = '/tmp'  # XXX
TEMPORARY_BUILD_DIR = "#{TEMPORARY_DIR}/phantomjs"

INSTALL_DIR = '/opt/phantomjs'

# prepare for this job
def prep
  `sudo apt-get update; sudo apt-get install build-essential chrpath git-core libssl-dev libfontconfig1-dev libXext-dev libx11-dev libicu-dev`
end

# download needed files
def download
  # clone
  puts "> cloning and checking out branch: #{PHANTOMJS_BRANCH}"
  `git clone #{PHANTOMJS_REPOSITORY} #{TEMPORARY_BUILD_DIR}; cd #{TEMPORARY_BUILD_DIR}; git checkout #{PHANTOMJS_BRANCH}`

  # download 3rd party files
  puts "> downloading 3rd party files..."
  `cd '#{TEMPORARY_BUILD_DIR}'; mkdir src/qt/src/3rdparty/pixman; cd src/qt/src/3rdparty/pixman; wget http://qt.gitorious.org/qt/qt/blobs/raw/4.8/src/3rdparty/pixman/README; wget http://qt.gitorious.org/qt/qt/blobs/raw/4.8/src/3rdparty/pixman/pixman-arm-neon-asm.h; wget http://qt.gitorious.org/qt/qt/blobs/raw/4.8/src/3rdparty/pixman/pixman-arm-neon-asm.S`
end

# edit header/config files
def edit
  ########
  # (referenced: https://github.com/aeberhardo/phantomjs-linux-armv6l)
  # - build.sh: comment out lines from 11 to 34
  filepath = "#{TEMPORARY_BUILD_DIR}/build.sh"
  puts "> editing file: #{filepath}"
  lines = File.readlines(filepath)
  from, to = 11, 34
  range = ((from - 1)..(to - 1))
  File.open(filepath, 'w') {|file|
    lines.each_with_index {|v, i|
      if range.include? i
        v = '#' + v unless v =~ /^#/
      end
      file << v
    }
  }
  # - src/qt/preconfig.sh: add an option
  filepath = "#{TEMPORARY_BUILD_DIR}/src/qt/preconfig.sh"
  puts "> editing file: #{filepath}"
  option = "QT_CFG+=' -no-pch'\n"
  lines = File.readlines(filepath)
  unless lines.include? option
    if lineno = lines.find_index {|x| x =~ /^QT_CFG\+=' -no-stl'/}
      lines.insert(lineno + 1, "QT_CFG+=' -no-pch'\n")
      File.open(filepath, 'w') {|file|
        lines.each {|x| file << x}
      }
    end
  end
  ########
  # (referenced: https://github.com/ariya/phantomjs/issues/10648#issuecomment-28056526)
  # - src/qt/config.tests/qpa/wayland/wayland.cpp: comment out non-existent header include
  filepath = "#{TEMPORARY_BUILD_DIR}/src/qt/config.tests/qpa/wayland/wayland.cpp"
  puts "> editing file: #{filepath}"
  incl = "#include <wayland-client.h>\n"
  lines = File.readlines(filepath).reject{|x| x == incl}
  File.open(filepath, 'w') {|file|
    lines.each {|x| file << x}
  }
  # - src/qt/src/3rdparty/webkit/Source/JavaScriptCore/JavaScriptCore.pri: uncomment 'CONFIG += text_breaking_with_icu'
  filepath = "#{TEMPORARY_BUILD_DIR}/src/qt/src/3rdparty/webkit/Source/JavaScriptCore/JavaScriptCore.pri"
  puts "> editing file: #{filepath}"
  commented = "# CONFIG += text_breaking_with_icu\n"
  lines = File.readlines(filepath)
  File.open(filepath, 'w') {|file|
    lines.each {|x|
      x.gsub!(/^#\s/, "") if x == commented
      file << x
    }
  }
end

# build files
def build
  started = Time.now
  puts "> building..."
  `cd '#{TEMPORARY_BUILD_DIR}'; ./build.sh --jobs 1 --confirm > build.sh.out 2> build.sh.err`
  puts "> packaging..."
  `cd '#{TEMPORARY_BUILD_DIR}'; ./deploy/package.sh > package.sh.out 2> package.sh.err`
  ended = Time.now
  puts "> it took #{ended - started} seconds"
end

# install
def install
  packaged = Dir["#{TEMPORARY_BUILD_DIR}/deploy/phantomjs*.tar.bz2"].first
  if packaged.nil?
    puts "* packaged file not found in: #{TEMPORARY_BUILD_DIR}/deploy/"
    exit 1
  else
    puts "> installing..."
    filename = File.basename(packaged)
    `sudo cp #{packaged} /opt/; cd /opt; sudo tar -xjf #{filename}`
    `sudo ln -sf /opt/#{filename.gsub('.tar.bz2', '')} #{INSTALL_DIR}`
    puts "> installed to: #{INSTALL_DIR}"
  end
end

# and cleanup
def cleanup
  puts "> cleaning up: #{TEMPORARY_BUILD_DIR}"
  `rm -rf '#{TEMPORARY_BUILD_DIR}'`
end

if __FILE__ == $0

  prep
  cleanup
  download
  edit
  build
  install
  cleanup

end

