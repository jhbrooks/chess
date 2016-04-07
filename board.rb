require_relative "./arrangement.rb"
require_relative "./square.rb"
require_relative "./piece.rb"

# This class handles Boards for games of chess
class Board
  attr_reader :line_w, :squares, :rows, :cols, :diags

  def initialize(players, line_w)
    @line_w = line_w
    @squares = create_squares(players)
    @rows = create_rows
    @cols = create_columns
    @diags = create_diagonals
  end

  def make_move(orig_pos, targ_pos)
    square(targ_pos).piece = square(orig_pos).piece
    square(orig_pos).piece = nil
  end

  def square(pos)
    squares.find do |s|
      s.pos == pos
    end
  end

  def legal_moves(orig_pos)
    valid_moves(orig_pos) + valid_captures(orig_pos)
  end

  def to_s
    f_string = "#{label_string.center(line_w)}\n"
    f_string << "#{(rows.map(&:to_s).join("\n"))}\n"
    f_string << "#{label_string.center(line_w)}\n\n"
  end

  private

  def create_squares(players)
    [create_black_squares(players[1]),
     create_empty_squares,
     create_white_squares(players[0])].flatten
  end

  def create_black_squares(player)
    [create_black_specials(player), create_black_pawns(player)].flatten
  end

  def create_black_specials(player)
    special_pieces(player).map.with_index do |piece, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 8, piece)
    end
  end

  def create_black_pawns(player)
    Array.new(8).map.with_index do |_e, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 7, Pawn.new(player))
    end
  end

  def create_empty_squares
    empty_squares = []
    6.downto(3) do |rank|
      8.times do |i|
        file = ("a".ord + i).chr.to_sym
        empty_squares << Square.new(file, rank, nil)
      end
    end
    empty_squares
  end

  def create_white_squares(player)
    [create_white_pawns(player), create_white_specials(player)].flatten
  end

  def create_white_pawns(player)
    Array.new(8).map.with_index do |_e, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 2, Pawn.new(player))
    end
  end

  def create_white_specials(player)
    special_pieces(player).map.with_index do |piece, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 1, piece)
    end
  end

  def special_pieces(player)
    [Rook.new(player), Knight.new(player),
     Bishop.new(player), Queen.new(player),
     King.new(player), Bishop.new(player),
     Knight.new(player), Rook.new(player)]
  end

  def create_rows
    Array.new(8).map.with_index do |_e, i|
      rank = 8 - i
      Row.new(rank, squares.select { |square| square.rank == rank }, line_w)
    end
  end

  def create_columns
    Array.new(8).map.with_index do |_e, i|
      file = ("a".ord + i).chr.to_sym
      Column.new(file, squares.select { |square| square.file == file })
    end
  end

  def create_diagonals
    [create_up_diagonals, create_down_diagonals].flatten
  end

  def create_up_diagonals
    Array.new(15).map.with_index do |_e, i|
      Arrangement.new(squares.select do |square|
        (square.file.to_s.ord - "a".ord) + (8 - square.rank) == i
      end)
    end
  end

  def create_down_diagonals
    Array.new(15).map.with_index do |_e, i|
      Arrangement.new(squares.select do |square|
        (square.file.to_s.ord - "a".ord) + square.rank == i + 1
      end)
    end
  end

  def valid_moves(orig_pos)
    origin = square(orig_pos)
    onboard_moves = origin.potential_moves.select do |m|
      squares.map(&:file).include?(m[0]) && squares.map(&:rank).include?(m[1])
    end

    base_valids = select_empties(onboard_moves)
    reject_invalid_moves(base_valids, origin)
  end

  def select_empties(moves)
    moves.select { |move| square(move).empty? }
  end

  def reject_invalid_moves(base_valids, origin)
    row_valids = reject_blocked_moves(rows, base_valids, origin)
    row_col_valids = reject_blocked_moves(cols, row_valids, origin)
    reject_blocked_moves(diags, row_col_valids, origin)
  end

  def reject_blocked_moves(arrangement_array, moves, origin)
    arrangement_array.each do |arrangement|
      blocked_moves = arrangement.relevant_blocked_squares(origin).map(&:pos)
      moves -= blocked_moves unless blocked_moves.empty?
    end
    moves
  end

  def valid_captures(orig_pos)
    origin = square(orig_pos)
    onboard_captures = origin.potential_captures.select do |c|
      squares.map(&:file).include?(c[0]) && squares.map(&:rank).include?(c[1])
    end

    base_valids = reject_empties_and_friendlies(onboard_captures, origin)
    reject_invalid_moves(base_valids, origin)
  end

  def reject_empties_and_friendlies(moves, origin)
    moves.reject { |move| square(move).empty? }.reject do |move|
      square(move).piece.player == origin.piece.player
    end
  end

  def label_string
    Array.new(8).map.with_index do |_e, i|
      " #{('a'.ord + i).chr} "
    end.join("")
  end
end
