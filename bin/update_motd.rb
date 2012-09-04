#!/usr/bin/env ruby
# coding: UTF-8

# update_motd.rb
# 
# script for updating MOTD
# (referenced: https://gist.github.com/3023588)
# 
# created on : 2012.08.21
# last update: 2012.09.04
# 
# by meinside@gmail.com

MOTD_LOGO = <<MOTD_LOGO

                        ..:~:=II77I++~,:.,,
                    ..~I777I7I7 I7 I7I777?+=:.,
                   :7 I77777 7 7 7777777 I7777.,
                 ,I 7777  77777777 777I7 7  777?.
                :777   7I 7 I7777 II I77II  I7  7.
               .77 I  77 7I7 7 77I 7?77I I  ?  77?.
               , II7? II  77 II7 II  ?7  7 II ? 77.
               =77 77777I 7I777777I77  7I 7I77 I 7.
               = 7777I77777I 77I7 7II I 777I 7 7 7,
               ?7II777I7 7777I  7 77I 777I  777??I.
               7I:7I7I7I7I7I7III7II7I 777 I 77I:~7,
               ?7.77  7I I7I 77 7 ?7I7I77 7  7I::7,
                I.77 777:..,::I7I?I7..,,.,=I777:~7.
                I,7II7:..,,.,..7II ,,..,....? 7.~I.
                :.77I7,.,.....~ 7 7....,....?  ?.
               :.=   7..,..:..7I7,?7...,,,.:77 7=.,
               .77II I:....,.III:.~7+,.:,.,,I7I7II.
               .77 77777I777777?..,I7777I777I 7 I+,
                    I7I7~=I7777,,,,.77I ~~777I~,
                          II7I7..,,,7I77
                      :...77I II777I 77I.,
                     .+7..,~II77I  7I7,.,,...
                    :.7I..7.,..,.,.,.,.7... I.
                     , 7.,..7.I=,7,7:+:,..=7I,
                     7I7=,,,,.:.~7.....+,.777.
  7 77=.,             I7 I,.7.7?~+.7~+=.:7II            ?II.
  77   I+,.            +I 77~,~.I7.,:,,I7I 7:        .=7I 7I?.:
  7 7I7  II,            ~7 III777777 I777 7          I7I II77,
  7 77I I 7? ?.           77 7 III777  7I,         = 777  ?~7 I 7
 ?7I? II7 77  II,           777777I I7I         .I 777I7 7?7I  7 7,
I7 +.=+:=~I777 7 77.:                         ~7 II7I?7I 77:7I77II
 + ?7I77 7II=.II77 777:,                   :7 II7I 7I7,.~??777 I?7
           :7 7I  7777  77~,           .+7 7 7I77II.?I77I777I?+=.
               ~I777 I77 7777I:     =I 77 77 777 I7777
                   7I7I 7777 77,.,II7 I7I7I7 7I7:
                      ~777I7,:I 77 I I 777I?
                          :=7III7 77 III=.
                      ~~777I7I777?77,,:77I7?I7:
                   ?7 II 77II7?I:   7?7777 I7 7 I 77~,
              :77 7777777  7+,        I77I I 777  7I7 I7I   7I7I=
=I7I 777 777  7 77777 I77=                +7I77I 7I7777III77I7~7II
?7 77I77 7 7I777~,77II,:                      ?777  777?7I?77?,~I7
:77 7+?77? I 7=II7?                               ?II 7,..7 7 ??7:
  77IIIIIIII= 77                                    7I77I+~I I~,
    77I,.,+I7I                                        7I77I7 7I
     77777??                                            :?7777

MOTD_LOGO

MOTD_FILEPATH = "/etc/motd"

def print_usage
	puts "* should login as root first"
end

if __FILE__ == $0
	if `whoami`.strip == 'root'
		begin
			File.open(MOTD_FILEPATH, "w"){|file|
				file << MOTD_LOGO
			}
			`/etc/init.d/bootlogs`
			puts "* MOTD was updated successfully"
		rescue
			puts $!
		end
	else
		print_usage
	end
end
