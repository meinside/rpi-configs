# .irbrc file for OSX
#
# meinside@gmail.com
#
# last update: 11.04.04.

require "rubygems"

# check if it's irb or macirb
case File.basename($0)
when "irb"
	# initialize wirble
	begin
		require "wirble"
		Wirble.init
		Wirble.colorize
	rescue
		puts "Wirble not installed"
	end
when "macirb"
	framework 'Cocoa'	# load Cocoa framework
	framework 'Foundation'	# load core foundation
	framework 'ScriptingBridge'	# load scripting bridge
end

# turn on auto completion
require "irb/completion"

# turn on auto indent
IRB.conf[:AUTO_INDENT] = true

# define ri helper function
def ri(*names)
	system(%{ri #{names.map{|name| name.to_s}.join(" ")}})
end

# custom libraries
MY_LIBRARY_PATH = "~/ruby/meinside"
$: << File.expand_path(MY_LIBRARY_PATH)

