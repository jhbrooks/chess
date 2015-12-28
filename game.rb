# This class operates a Game of chess
class Game
  attr_accessor :state

  def initialize
    @state = nil
  end

  def set_up
    welcome_user
    request_command
  end

  def play
    until game_over?
      puts state
      move = determine_move
      make_move(move)
      game_over? ? puts(state) : advance_turn
    end
  end

  def welcome_user
    puts "\nWelcome to Ruby Chess!"
  end

  def request_command
    cmd = nil
    until command_valid?(cmd)
      puts "You can START, LOAD, or QUIT. What would you like to do?"
      cmd = STDIN.gets.chomp.upcase
      if command_valid?(cmd)
        execute_command(cmd)
      else
        puts "Invalid command! Please try again.\n\n"
      end
    end
  end

  def command_valid?(cmd)
    case cmd
    when "START" then true
    when "LOAD" then true
    when "QUIT" then true
    else
      false
    end
  end

  def execute_command(cmd)
    case cmd
    when "START" then start_game
    when "LOAD" then load_game
    when "QUIT" then quit_game
    end
  end

  # The following methods are not yet implemented
  def start_game
    false
  end

  def load_game
    false
  end

  def quit_game
    false
  end

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
