require_relative "./state.rb"
require_relative "./player.rb"
require_relative "./piece.rb"
require 'yaml'

# This class operates Games of chess.
# Use Game.new.set_up to begin.
class Game


  attr_reader :setup_commands, :play_commands, :special_moves, :pawn_promotions
  attr_accessor :state, :quit_status

  def initialize
    @state = nil
    @quit_status = nil
    @setup_commands = { "START" => :start_game, "LOAD" => :load_game,
                        "QUIT" => :quit_game }
    @play_commands = { "MOVE" => :determine_and_make_move,
                       "" => :determine_and_make_move,
                       "SAVE" => :save_game, "QUIT" => :quit_game }
    @special_moves = %w(EP CL CS)
    @pawn_promotions = %w(Bishop Knight Pawn Queen Rook)
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
      puts "You can START, LOAD, or QUIT."
      STDOUT.print "What would you like to do? "
      cmd = STDIN.gets.chomp.upcase
      if setup_command_valid?(cmd)
        execute_command(cmd)
      else
        STDOUT.print "Invalid command! Please try again.\n\n"
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
    STDOUT.print "Please input White's name: "
    w_name = STDIN.gets.chomp
    STDOUT.print "Please input Black's name: "
    b_name = STDIN.gets.chomp
    players = [Player.new(w_name, :White), Player.new(b_name, :Black)]
    self.state = State.new(players, 80)
    play
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
      puts "You can MOVE (hit ENTER), SAVE, or QUIT."
      STDOUT.print "What would you like to do? "
      cmd = STDIN.gets.chomp.upcase
      if play_command_valid?(cmd)
        execute_command(cmd)
      else
        STDOUT.print "Invalid command! Please try again.\n\n"
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
    STDOUT.print "Are you sure? Please respond YES or NO: "
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
      puts "Invalid input! Please try again." unless orig_pos == [nil, nil]
      STDOUT.print "Input where you'd like to move from: "
      orig_pos = STDIN.gets.chomp.downcase.+("  ").split("")
      orig_pos = [orig_pos[0].to_sym, orig_pos[1].to_i]
    end
    orig_pos
  end

  # Requires state to have the #valid_targ_pos? method.
  def determine_targ_pos(orig_pos)
    targ_pos = [nil, nil]
    until state.valid_targ_pos?(orig_pos, targ_pos)
      puts "Invalid input! Please try again." unless targ_pos == [nil, nil]
      puts "Input where you'd like to move to, or DROP the piece."
      puts "  If appropriate, you may also input a special move."
      STDOUT.print "  (EP for en passant, "\
                      "CL for castle long, "\
                      "CS for castle short): "
      targ_pos = STDIN.gets.chomp.downcase.+("  ").split("")
      return false if targ_pos.join("").upcase.include?("DROP")
      if special_moves.include?(targ_pos[0..1].join("").upcase)
        targ_pos = targ_pos[0..1].join("").upcase
      else
        targ_pos = [targ_pos[0].to_sym, targ_pos[1].to_i]
      end
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
  # Requires state to have the #en_pass_pos method.
  # Requires state to have the #pawn_moved_two method.
  # Requires state to have the #last_orig_piece method.
  # Requires state to have the #last_targ_piece method.
  def take_post_move_actions(orig_pos, targ_pos)
    if state.last_targ_piece
      if state.last_targ_piece.player.color != state.current_player.color
        puts "\n#{state.last_orig_piece} captures #{state.last_targ_piece}."
      end
    end

    if !special_moves.include?(targ_pos) && state.pawn_for_promotion(targ_pos)
      promote_pawn(targ_pos)
    end

    if game_over?
      puts(state)
    else
      puts "\nCheck." if state.next_player.in_check
      advance_turn
      adjust_en_pass_pos(orig_pos, targ_pos)
    end
  end

  def promote_pawn(targ_pos)
    piece = nil
    puts "\nPawn promotion achieved!"
    while piece.nil?
      STDOUT.print "Input the piece you'd like to promote your pawn into: "
      player = state.board.square(targ_pos).piece.player
      piece = STDIN.gets.chomp.capitalize
      if pawn_promotion_valid?(piece)
        state.board.square(targ_pos).piece = Object.const_get(piece)
                                                   .create(player)
        puts "Pawn promoted into a #{piece.downcase}."
        state.players.each do |player|
          state.adjust_check_status(player)
        end
      else
        piece = nil
        puts "Invalid piece! Please try again."
      end
    end
  end

  def pawn_promotion_valid?(piece)
    pawn_promotions.include?(piece)
  end

  # Requires state to have the #turn= method
  def advance_turn
    state.turn += 1
  end

  # Requires state to have the #en_pass_pos method.
  # Requires state to have the #pawn_moved_two method.
  def adjust_en_pass_pos(orig_pos, targ_pos)
    if special_moves.include?(targ_pos)
      state.en_pass_pos = nil
      return
    end

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

  def save_game
    game_saved = false
    until game_saved
      STDOUT.print "Please name your save: "
      filename = STDIN.gets.chomp
      if !File.exist?("saves/#{filename}")
        File.open("saves/#{filename}", "w") do |f|
          f.puts(YAML.dump(state))
        end
        puts "Game saved."
        game_saved = true
      else
        response = nil
        until response == "YES" || response == "NO"
          STDOUT.print "Overwrite existing file? Please respond YES or NO: "
          response = STDIN.gets.chomp.upcase
        end
        if response == "YES"
          File.open("saves/#{filename}", "w") do |f|
            f.write(YAML.dump(state))
          end
          puts "File overwritten. Game saved."
          game_saved = true
        else
          puts "File not overwritten. Trying again."
        end
      end
    end
  end

  def load_game
    game_loaded = false
    load_canceled = false
    until game_loaded || load_canceled
      STDOUT.print "Please input the name of your save (or input CANCEL): "
      filename = STDIN.gets.chomp
      if File.exist?("saves/#{filename}")
        File.open("saves/#{filename}", "r") do |f|
          self.state = YAML.load(f.read)
        end
        puts "Game loaded. Restarting play."
        game_loaded = true
        play
      elsif filename.upcase == "CANCEL"
        puts "Load canceled. Returning to setup."
        load_canceled = true
        set_up
      else
        puts "Load failed (no save with that name found). Trying again."
      end
    end
  end
end
