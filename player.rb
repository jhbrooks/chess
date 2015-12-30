# This class handles Players in a game of chess
class Player
  attr_reader :name, :color
  attr_accessor :in_check

  def initialize(name, color)
    @name = name
    @color = color
    @in_check = false
  end

  # Though not required, color should be capitalized for ideal #mark output
  def mark
    "#{color}"[0]
  end

  # Though not required, color should be capitalized for ideal #to_s output
  def to_s
    "#{color} (#{name})"
  end
end
