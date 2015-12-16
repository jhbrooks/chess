# This class handles Pieces in a game of chess
class Piece
  attr_reader :player, :type

  def initialize(player, type)
    @player = player
    @type = type
  end
end
