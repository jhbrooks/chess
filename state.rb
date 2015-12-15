# This class handles the State of a game of chess
class State
  attr_reader :players, :line_w
  attr_accessor :turn, :board

  def initialize(turn, players, board, line_w)
    @turn = turn
    @players = players
    @board = board
    @line_w = line_w
  end

  def current_player
    players[(turn - 1) % players.length]
  end
end
