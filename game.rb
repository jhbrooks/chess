require_relative "./state.rb"
require_relative "./player.rb"

# This class operates Games of chess.
# Use Game.new.set_up to begin.
class Game
  attr_reader :setup_commands, :play_commands
  attr_accessor :state, :quit_status

  def initialize
    @state = nil
    @quit_status = nil
    @setup_commands = { "START" => :start_game, "LOAD" => :load_game,
                        "QUIT" => :quit_game }
    @play_commands = { "MOVE" => :determine_and_make_move,
                       "SAVE" => :save_game, "QUIT" => :quit_game }
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
    setup_commands.keys.include?(cmd)
  end

  def execute_command(cmd)
    send(setup_commands.merge(play_commands)[cmd])
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
    reset_game
    set_up
  end

  def game_over?
    quit_status || state.game_over?
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
    play_commands.keys.include?(cmd)
  end

  # Requires state to have the #current_player method
  def quit_game
    state.nil? ? quit_setup : quit_play
  end

  def quit_setup
    puts "\nGoodbye!"
  end

  # Requires state to have the #current_player method
  def quit_play
    puts "Are you sure? Please respond YES or NO."
    return unless STDIN.gets.chomp.upcase == "YES"
    self.quit_status = true
    puts "\n#{state.current_player} has quit!"
  end

  # Requires state to have the #valid_orig_pos? method.
  # Require state to have the #valid_targ_pos? method.
  # Requires state to have the #next_player method.
  # Requires state to have the #current_player method.
  # Requires state to have the #make_move method.
  def determine_and_make_move
    orig_pos = determine_orig_pos
    targ_pos = determine_targ_pos(orig_pos)
    make_move(orig_pos, targ_pos) if targ_pos
  end

  # Requires state to have the #valid_orig_pos? method
  def determine_orig_pos
    orig_pos = [nil, nil]
    until state.valid_orig_pos?(orig_pos)
      puts "Invalid input! Please try again.\n\n" unless orig_pos == [nil, nil]
      puts "Input where (e.g. a1) you'd like to move from."
      orig_pos = STDIN.gets.chomp.downcase.+("  ").split("")
      orig_pos = [orig_pos[0].to_sym, orig_pos[1].to_i]
    end
    orig_pos
  end

  # Require state to have the #valid_targ_pos? method.
  def determine_targ_pos(orig_pos)
    targ_pos = [nil, nil]
    until state.valid_targ_pos?(orig_pos, targ_pos)
      puts "Invalid input! Please try again.\n\n" unless targ_pos == [nil, nil]
      puts "Input where you'd like to move to (or DROP the piece)."
      targ_pos = STDIN.gets.chomp.downcase.+("  ").split("")
      return false if targ_pos.join("").upcase.include?("DROP")
      targ_pos = [targ_pos[0].to_sym, targ_pos[1].to_i]
    end
    targ_pos
  end

  # Requires state to have the #make_move method.
  # Requires state to have the #next_player method.
  # Requires state to have the #current_player method.
  def make_move(orig_pos, targ_pos)
    state.make_move(orig_pos, targ_pos)
    take_post_move_actions(orig_pos, targ_pos)
  end

  # Requires state to have the #next_player method.
  # Requires state to have the #current_player method.
  # Requires state to have the #en_pass_pos method.
  # Requires state to have the #pawn_moved_two method.
  def take_post_move_actions(orig_pos, targ_pos)
    if game_over?
      state.next_player.in_check ? puts("Checkmate!") : puts("Draw.")
      puts(state)
    else
      advance_turn
      puts "Check." if state.current_player.in_check
      adjust_en_pass_pos(orig_pos, targ_pos)
    end
  end

  # Requires state to have the #turn= method
  def advance_turn
    state.turn += 1
  end

  def adjust_en_pass_pos(orig_pos, targ_pos)
    if state.pawn_moved_two(orig_pos, targ_pos)
      state.en_pass_pos = targ_pos
    else
      state.en_pass_pos = nil
    end
  end

  def reset_game
    self.state = nil
    self.quit_status = nil
  end

  # The following method is not yet implemented
  def save_game
    false
  end
end
