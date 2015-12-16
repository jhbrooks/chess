# This class handle a Player in a game of chess
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
