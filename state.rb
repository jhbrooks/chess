require_relative "./board.rb"

# This class handles the State of a game of chess
class State
  attr_reader :players, :board, :line_w
  attr_accessor :turn

  def initialize(players, line_w)
    @players = players
    @line_w = line_w
    @turn = 1
    @board = Board.new(players, line_w)
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
    "#{current_player} to play."
  end
end
