# .irbrc file
#
# meinside@gmail.com
#
# last update: 14.02.07.

require "rubygems"

# check if it's irb or macirb
case File.basename($0)
when "irb"
	# initialize wirble
	begin
		require "wirble"
		Wirble::Colorize.colors = Wirble::Colorize.colors.merge({
			#object_class: :white,
		})
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

# definitions of irb helper functions
def clear
	system 'clear'
end

class Object
	def own_methods(omit_superclass_methods = true)
		omit_superclass_methods ? 
			(self.methods - self.class.superclass.instance_methods).sort : 
			(self.methods - Object.instance_methods).sort
	end

	def ri(obj = self)
		puts `ri '#{obj.kind_of?(String) ? obj : (obj.class == Class ? obj : obj.class)}'`
	end
end

# for loading gems installed from git with bundler
require 'bundler/setup'

