require_relative "./board.rb"

# This class handles States of games of chess
class State
  attr_reader :players, :board, :line_w
  attr_accessor :turn, :last_orig_piece, :last_targ_piece,
                :last_check_status, :last_unmoved_status

  def initialize(players, line_w)
    @players = players
    @line_w = line_w
    @turn = 1
    @board = Board.new(players, line_w)
    @last_orig_piece = nil
    @last_targ_piece = nil
    @last_check_status = nil
    @last_unmoved_status = nil
  end

  def current_player
    players[(turn - 1) % players.length]
  end

  def next_player
    players[turn % players.length]
  end

  def valid_orig_pos?(orig_pos)
    origin = board.square(orig_pos)
    origin && !origin.empty? && origin.piece.player == current_player
  end

  def valid_targ_pos?(orig_pos, targ_pos)
    board_legals = board.legal_moves(orig_pos).include?(targ_pos)
    state_legals = legal_moves(orig_pos).include?(targ_pos)
    puts "That move would leave you in check." if board_legals && !state_legals
    state_legals
  end

  def legal_moves(orig_pos)
    state_legal_moves = []
    board.legal_moves(orig_pos).each do |move|
      store_last_move(orig_pos, move)
      make_move(orig_pos, move)
      state_legal_moves << move unless current_player.in_check
      undo_move(orig_pos, move)
    end
    state_legal_moves
  end

  # Requires all players to have the #in_check= method
  def make_move(orig_pos, targ_pos)
    board.make_move(orig_pos, targ_pos)
    adjust_unmoved_status(targ_pos)
    players.each do |player|
      adjust_check_status(player)
    end
  end

  def game_over?
    over = false
    self.turn += 1
    friendlies = non_empties.select { |s| s.piece.player == current_player }
    over = true if friendlies.all? { |s| legal_moves(s.pos).empty? }
    self.turn -= 1
    over
  end

  def to_s
    f_string = "\n#{status_string.center(line_w)}\n\n"
    f_string << "#{board}"
  end

  private

  def store_last_move(orig_pos, targ_pos)
    self.last_orig_piece = board.square(orig_pos).piece
    self.last_unmoved_status = last_orig_piece.unmoved
    self.last_targ_piece = board.square(targ_pos).piece
    self.last_check_status = current_player.in_check
  end

  def undo_move(orig_pos, targ_pos)
    last_orig_piece.unmoved = last_unmoved_status
    board.square(orig_pos).piece = last_orig_piece
    board.square(targ_pos).piece = last_targ_piece
    current_player.in_check = last_check_status
  end

  def non_empties
    board.squares.reject(&:empty?)
  end

  # Requires piece to have the #unmoved= method
  def adjust_unmoved_status(pos)
    board.square(pos).piece.unmoved = false
  end

  # Requires all players to have the #in_check= method
  def adjust_check_status(player)
    enemies = non_empties.select { |s| s.piece.player != player }
    player.in_check = moves_for_squares(enemies).any? do |moves|
      moves.include?(king_square(player).pos)
    end
  end

  def moves_for_squares(sqrs)
    sqrs.map { |s| board.legal_moves(s.pos) }
  end

  def king_square(player)
    non_empties.find { |s| s.piece.player == player && s.piece.is_a?(King) }
  end

  def status_string
    "#{current_player} to play."
  end
end
