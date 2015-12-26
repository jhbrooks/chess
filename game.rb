# This class operates a Game of chess
class Game
  attr_accessor :state

  def initialize
    @state = nil
  end

  def play
    until game_over?
      puts state
      move = determine_move
      make_move(move)
      game_over? ? puts(state) : advance_turn
    end
  end

  # The following methods are not yet implemented
  def game_over?
    false
  end

  def determine_move
    false
  end

  def make_move(_move)
    false
  end

  def advance_turn
    false
  end
end
