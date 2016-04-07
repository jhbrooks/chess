# To run the chess program, navigate (via command-line) to the directory
# containing this file, open an irb console, and input "load 'chess.rb'". Due
# to the size of Unicode chess symbols, it may also be helpful to increase the
# font size in your command-line interface, before playing.

require_relative "./game.rb"

Game.new.set_up
