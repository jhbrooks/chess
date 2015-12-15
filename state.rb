# This class handles the State of a game of chess
class State
  attr_reader :players, :board, :line_w
  attr_accessor :turn

  def initialize(turn, players, board, line_w)
    @turn = turn
    @players = players
    @board = board
    @line_w = line_w
  end

  def current_player
    players[(turn - 1) % players.length]
  end

  def to_s
    f_string = "\n#{status_string.center(line_w)}\n\n"
    f_string << "#{board}"
  end

  private

  def status_string
    "It is #{current_player}'s turn."
  end
end
