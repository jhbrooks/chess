require_relative "./board.rb"

# This class handles States of games of chess
class State
  attr_reader :players, :board, :line_w
  attr_accessor :turn, :last_orig_piece, :last_targ_piece, :last_check_status

  def initialize(players, line_w)
    @players = players
    @line_w = line_w
    @turn = 1
    @board = Board.new(players, line_w)
    @last_orig_piece = nil
    @last_targ_piece = nil
    @last_check_status = nil
  end

  def current_player
    players[(turn - 1) % players.length]
  end

  def valid_origin?(position)
    origin = board.square(position)
    origin && !origin.empty? && origin.piece.player == current_player
  end

  def valid_target?(origin, target)
    legal_moves(origin).include?(target)
  end

  def legal_moves(origin)
    state_legal_moves = []
    board.legal_moves(origin).each do |move|
      store_last_move(origin, move)
      make_move(origin, move)
      state_legal_moves << move unless current_player.in_check
      undo_move(origin, move)
    end
    state_legal_moves
  end

  # Requires all players to have the #in_check= method
  def make_move(orig_pos, targ_pos)
    board.make_move(orig_pos, targ_pos)
    players.each do |p|
      non_empties = board.squares.reject(&:empty?)
      enemy_squares = non_empties.select { |s| s.piece.player != p }
      k = non_empties.find { |s| s.piece.player == p && s.piece.is_a?(King) }
      e_moves = enemy_squares.map { |e| board.legal_moves([e.file, e.rank]) }
      p.in_check = e_moves.any? { |mvs| mvs.include?([k.file, k.rank]) }
    end
  end

  def to_s
    f_string = "\n#{status_string.center(line_w)}\n\n"
    f_string << "#{board}"
  end

  private

  def store_last_move(origin, target)
    self.last_orig_piece = board.square(origin).piece
    self.last_targ_piece = board.square(target).piece
    self.last_check_status = current_player.in_check
  end

  def undo_move(origin, target)
    board.square(origin).piece = last_orig_piece
    board.square(target).piece = last_targ_piece
    current_player.in_check = last_check_status
  end

  def status_string
    "#{current_player} to play."
  end
end
