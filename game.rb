require_relative "./state.rb"
require_relative "./player.rb"

# This class operates a Game of chess
class Game
  attr_accessor :state, :quit_status

  def initialize
    @state = nil
    @quit_status = nil
  end

  def set_up
    welcome_user
    request_setup_command
  end

  def welcome_user
    puts "\nWelcome to Ruby Chess!"
  end

  def request_setup_command
    cmd = nil
    until setup_command_valid?(cmd)
      puts "You can START, LOAD, or QUIT. What would you like to do?"
      cmd = STDIN.gets.chomp.upcase
      if setup_command_valid?(cmd)
        execute_command(cmd)
      else
        puts "Invalid command! Please try again.\n\n"
      end
    end
  end

  def setup_command_valid?(cmd)
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
    when "MOVE" then determine_and_make_move
    when "SAVE" then save_game
    end
  end

  def start_game
    puts "Please input White's name."
    w_name = STDIN.gets.chomp
    puts "Please input Black's name."
    b_name = STDIN.gets.chomp
    players = [Player.new(w_name, :White), Player.new(b_name, :Black)]
    self.state = State.new(players, 80)
    play
  end

  # The following method is not yet implemented
  def load_game
    false
  end

  def play
    until game_over?
      puts state
      request_play_command
    end
  end

  def game_over?
    quit_status
  end

  def request_play_command
    cmd = nil
    until play_command_valid?(cmd)
      puts "You can MOVE, SAVE, or QUIT. What would you like to do?"
      cmd = STDIN.gets.chomp.upcase
      if play_command_valid?(cmd)
        execute_command(cmd)
      else
        puts "Invalid command! Please try again.\n\n"
      end
    end
  end

  def play_command_valid?(cmd)
    case cmd
    when "MOVE" then true
    when "SAVE" then true
    when "QUIT" then true
    else
      false
    end
  end

  # Requires state to have the #current_player method
  def quit_game
    puts "Are you sure? Please respond YES or NO."
    confirmation = STDIN.gets.chomp.upcase
    return unless confirmation == "YES"
    self.quit_status = true
    if state.nil?
      puts "\nGoodbye!"
    else
      puts "\n#{state.current_player} has quit!"
    end
  end

  def determine_and_make_move
    move = determine_move
    make_move(move)
  end

  def make_move(_move)
    game_over? ? puts(state) : advance_turn
  end

  # Requires state to have the #turn= method
  def advance_turn
    state.turn += 1
  end

  # The following methods are not yet implemented
  def save_game
    false
  end

  def determine_move
    false
  end
end
