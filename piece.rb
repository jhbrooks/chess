# This class handles Pieces in a game of chess
class Piece
  attr_reader :player, :type

  def initialize(player, type)
    @player = player
    @type = type
  end

  # Requires player to have the #mark method
  def mark
    type_mark = "#{type}"[0]
    "#{player.mark}#{type_mark}"
  end

  def to_s
    "#{player} #{type}"
  end
end

class Bishop < Piece
  def self.create(player)
    new(player, :Bishop)
  end
end
