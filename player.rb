# This class handle a Player in a game of chess
class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def mark
    "#{color}"[0]
  end

  def to_s
    "#{color} (#{name})"
  end
end
