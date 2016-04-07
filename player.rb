# This class handles Players in a game of chess
class Player
  attr_reader :name, :color
  attr_accessor :in_check

  def initialize(name, color)
    @name = name
    @color = color
    @in_check = false
  end

  def to_s
    "#{color} (#{name})"
  end
end
