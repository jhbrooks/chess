require_relative "./board.rb"
require_relative "./piece.rb"

# This class handles States of games of chess
class State
  attr_reader :players, :board, :line_w, :special_moves
  attr_accessor :turn, :last_orig_piece, :last_targ_piece,
                :last_unmoved_status, :en_pass_pos

  def initialize(players, line_w)
    @players = players
    @line_w = line_w
    @turn = 1
    @board = Board.new(players, line_w)
    @last_orig_piece = nil
    @last_targ_piece = nil
    @last_unmoved_status = nil
    @en_pass_pos = nil
    @special_moves = %w(EP CL CS)
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
    legal_after_check = legal_moves(orig_pos).include?(targ_pos)
    if legal_before_check(orig_pos, targ_pos) && !legal_after_check
      puts "That move would leave you in check."
    end
    legal_after_check
  end

  def legal_moves(orig_pos)
    state_legal_moves = []
    board_and_special_moves(orig_pos).each do |move|
      make_move(orig_pos, move)
      state_legal_moves << move unless current_player.in_check
      undo_move(orig_pos, move)
    end
    state_legal_moves
  end

  def board_and_special_moves(orig_pos)
    board.legal_moves(orig_pos) + legal_special_moves(orig_pos)
  end

  def legal_before_check(orig_pos, targ_pos)
    board_and_special_moves(orig_pos).include?(targ_pos)
  end

  def legal_special_moves(orig_pos)
    piece = board.square(orig_pos).piece
    case
    when piece.is_a?(Pawn) then legal_en_passants(orig_pos)
    when piece.is_a?(King) then legal_castles(orig_pos)
    else
      []
    end
  end

  def legal_en_passants(orig_pos)
    return [] unless en_pass_pos
    file_diff = (en_pass_pos[0].to_s.ord - orig_pos[0].to_s.ord).abs
    rank_diff = en_pass_pos[1] - orig_pos[1]
    (file_diff == 1 && rank_diff == 0) ? ["EP"] : []
  end

  def legal_castles(orig_pos)
    return [] unless board.square(orig_pos).piece.unmoved
    legal_castle_longs(board.square(orig_pos).piece.player)
      .+(legal_castle_shorts(board.square(orig_pos).piece.player))
  end

  def legal_castle_longs(player)
    if player.color == :White && path_clear?([[:b, 1], [:c, 1], [:d, 1]])
      unless threatened?([[:c, 1], [:d, 1], [:e, 1]], player)
        if valid_rook?(board.square([:a, 1]).piece, player)
          return ["CL"]
        end
      end
    elsif player.color == :Black && path_clear?([[:b, 8], [:c, 8], [:d, 8]])
      unless threatened?([[:c, 8], [:d, 8], [:e, 8]], player)
        if valid_rook?(board.square([:a, 8]).piece, player)
          return ["CL"]
        end
      end
    end
    []
  end

  def legal_castle_shorts(player)
    if player.color == :White && path_clear?([[:f, 1], [:g, 1]])
      unless threatened?([[:e, 1], [:f, 1], [:g, 1]], player)
        if valid_rook?(board.square([:h, 1]).piece, player)
          return ["CS"]
        end
      end
    elsif player.color == :Black && path_clear?([[:f, 8], [:g, 8]])
      unless threatened?([[:e, 8], [:f, 8], [:g, 8]], player)
        if valid_rook?(board.square([:h, 8]).piece, player)
          return ["CS"]
        end
      end
    end
    []
  end

  def path_clear?(move_path)
    move_path.none? { |pos| non_empties.include?(board.square(pos)) }
  end

  def threatened?(move_path, player)
    enemies = non_empties.select { |s| s.piece.player != player }
    move_path.any? do |move|
      moves_for_squares(enemies).any? do |moves|
        moves.include?(move)
      end
    end
  end

  def valid_rook?(piece, player)
    piece && piece.is_a?(Rook) && piece.unmoved && piece.player == player
  end

  # Requires all players to have the #in_check= method
  def make_move(orig_pos, targ_pos)
    store_move(orig_pos, targ_pos)
    adjust_unmoved_status(orig_pos)
    if special_moves.include?(targ_pos)
      make_special_move(orig_pos, targ_pos)
    else
      board.make_move(orig_pos, targ_pos)
    end
    players.each do |player|
      adjust_check_status(player)
    end
  end

  def make_special_move(orig_pos, targ_pos)
    origin_color = board.square(orig_pos).piece.player.color
    if targ_pos == "EP"
      make_en_passant(orig_pos, origin_color)
    elsif targ_pos == "CL"
      make_castle_long(origin_color)
    else
      make_castle_short(origin_color)
    end
  end

  def make_en_passant(orig_pos, origin_color)
    adj = origin_color == :White ? 1 : (-1)
    board.make_move(orig_pos, [en_pass_pos[0], en_pass_pos[1] + adj])
    board.square(en_pass_pos).piece = nil
  end

  def make_castle_long(origin_color)
    if origin_color == :White
      board.make_move([:e, 1], [:c, 1])
      adjust_unmoved_status([:a, 1])
      board.make_move([:a, 1], [:d, 1])
    else
      board.make_move([:e, 8], [:c, 8])
      adjust_unmoved_status([:a, 8])
      board.make_move([:a, 8], [:d, 8])
    end
  end

  def make_castle_short(origin_color)
    if origin_color == :White
      board.make_move([:e, 1], [:g, 1])
      adjust_unmoved_status([:h, 1])
      board.make_move([:h, 1], [:f, 1])
    else
      board.make_move([:e, 8], [:g, 8])
      adjust_unmoved_status([:h, 8])
      board.make_move([:h, 8], [:f, 8])
    end
  end

  def store_move(orig_pos, targ_pos)
    self.last_orig_piece = board.square(orig_pos).piece
    self.last_unmoved_status = last_orig_piece.unmoved

    if special_moves.include?(targ_pos)
      store_special_move(orig_pos, targ_pos)
    else
      self.last_targ_piece = board.square(targ_pos).piece
    end
  end

  def store_special_move(orig_pos, targ_pos)
    origin_color = board.square(orig_pos).piece.player.color
    if targ_pos == "EP"
      store_en_passant
    elsif targ_pos == "CL"
      store_castle_long(origin_color)
    else
      store_castle_short(origin_color)
    end
  end

  def store_en_passant
    self.last_targ_piece = board.square(en_pass_pos).piece
  end

  def store_castle_long(origin_color)
    if origin_color == :White
      self.last_targ_piece = board.square([:a, 1]).piece
    else
      self.last_targ_piece = board.square([:a, 8]).piece
    end
  end

  def store_castle_short(origin_color)
    if origin_color == :White
      self.last_targ_piece = board.square([:h, 1]).piece
    else
      self.last_targ_piece = board.square([:h, 8]).piece
    end
  end

  def undo_move(orig_pos, targ_pos)
    last_orig_piece.unmoved = last_unmoved_status
    board.square(orig_pos).piece = last_orig_piece

    if special_moves.include?(targ_pos)
      undo_special_move(orig_pos, targ_pos)
    else
      board.square(targ_pos).piece = last_targ_piece
    end

    players.each do |player|
      adjust_check_status(player)
    end
  end

  def undo_special_move(orig_pos, targ_pos)
    origin_color = board.square(orig_pos).piece.player.color
    if targ_pos == "EP"
      undo_en_passant(origin_color)
    elsif targ_pos == "CL"
      undo_castle_long(origin_color)
    else
      undo_castle_short(origin_color)
    end
  end

  def undo_en_passant(origin_color)
    board.square(en_pass_pos).piece = last_targ_piece
    adj = origin_color == :White ? 1 : (-1)
    pos_to_empty = [en_pass_pos[0], en_pass_pos[1] + adj]
    board.square(pos_to_empty).piece = nil
  end

  def undo_castle_long(origin_color)
    if origin_color == :White
      board.square([:c, 1]).piece = nil

      board.square([:a, 1]).piece = last_targ_piece
      undo_adjust_unmoved_status([:a, 1])
      board.square([:d, 1]).piece = nil
    else
      board.square([:c, 8]).piece = nil

      board.square([:a, 8]).piece = last_targ_piece
      undo_adjust_unmoved_status([:a, 8])
      board.square([:d, 8]).piece = nil
    end
  end

  def undo_castle_short(origin_color)
    if origin_color == :White
      board.square([:g, 1]).piece = nil

      board.square([:h, 1]).piece = last_targ_piece
      undo_adjust_unmoved_status([:h, 1])
      board.square([:f, 1]).piece = nil
    else
      board.square([:g, 8]).piece = nil

      board.square([:h, 8]).piece = last_targ_piece
      undo_adjust_unmoved_status([:h, 8])
      board.square([:f, 8]).piece = nil
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

  def pawn_for_promotion?(targ_pos)
    board.square(targ_pos).piece.is_a?(Pawn) && [1, 8].include?(targ_pos[1])
  end

  def pawn_moved_two?(orig_pos, targ_pos)
    difference = (orig_pos[1] - targ_pos[1]).abs
    board.square(targ_pos).piece.is_a?(Pawn) && difference == 2
  end

  # Requires all players to have the #in_check= method
  def adjust_check_status(player)
    enemies = non_empties.select { |s| s.piece.player != player }
    player.in_check = moves_for_squares(enemies).any? do |moves|
      moves.include?(king_square(player) && king_square(player).pos)
    end
  end

  def to_s
    f_string = "\n#{status_string.center(line_w)}\n\n"
    f_string << "#{board}"
  end

  private

  def non_empties
    board.squares.reject(&:empty?)
  end

  # Requires piece to have the #unmoved= method
  def adjust_unmoved_status(pos)
    board.square(pos).piece.unmoved = false
  end

  # Requires piece to have the #unmoved= method
  def undo_adjust_unmoved_status(pos)
    board.square(pos).piece.unmoved = true
  end

  def moves_for_squares(sqrs)
    sqrs.map { |s| board.legal_moves(s.pos) }
  end

  def king_square(player)
    non_empties.find { |s| s.piece.player == player && s.piece.is_a?(King) }
  end

  def status_string
    if game_over?
      if next_player.in_check
        "Checkmate! #{current_player} has won."
      else
        "Draw! #{current_player} and #{next_player} have tied."
      end
    else
      "#{current_player} to play."
    end
  end
end
