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

  # Requires a valid original position
  def make_move(orig_pos, targ_pos)
    return false unless legal_moves(orig_pos).include?(targ_pos)
    square(targ_pos).piece = square(orig_pos).piece
    square(orig_pos).piece = nil
    true
  end

  def square(position)
    return false unless position.length == 2
    squares.find do |square|
      square.file == position[0] && square.rank == position[1]
    end
  end

  def legal_moves(position)
    winnowed_moves(position) + winnowed_captures(position)
  end

  def to_s
    adjustment = (line_w / 2) + (label_string.length / 2)
    f_string = "#{label_string.rjust(adjustment)}\n"
    f_string << "#{(rows.map(&:to_s).join("\n"))}\n\n"
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
      Square.new(file, 7, Pawn.create(player))
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
      Square.new(file, 2, Pawn.create(player))
    end
  end

  def create_white_specials(player)
    special_pieces(player).map.with_index do |piece, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 1, piece)
    end
  end

  def special_pieces(player)
    [Rook.create(player), Knight.create(player),
     Bishop.create(player), Queen.create(player),
     King.create(player), Bishop.create(player),
     Knight.create(player), Rook.create(player)]
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

  def winnowed_moves(position)
    origin = square(position)
    onboard_moves = origin.potential_moves.select do |m|
      squares.map(&:file).include?(m[0]) && squares.map(&:rank).include?(m[1])
    end

    delete_invalid_moves(onboard_moves, origin)

    onboard_moves
  end

  def delete_invalid_moves(onboard_moves, origin)
    delete_row_blocked_moves(onboard_moves, origin)
    delete_col_blocked_moves(onboard_moves, origin)
    delete_diag_blocked_moves(onboard_moves, origin)
  end

  def delete_row_blocked_moves(onboard_moves, origin)
    rows.each do |row|
      onboard_moves.delete_if do |pos|
        row_blocked_moves(row, origin).include?(pos)
      end
    end
  end

  def row_blocked_moves(row, origin)
    row.blocked_moves(origin).map { |square| [square.file, square.rank] }
  end

  def delete_col_blocked_moves(onboard_moves, origin)
    cols.each do |col|
      onboard_moves.delete_if do |pos|
        col_blocked_moves(col, origin).include?(pos)
      end
    end
  end

  def col_blocked_moves(col, origin)
    col.blocked_moves(origin).map { |square| [square.file, square.rank] }
  end

  def delete_diag_blocked_moves(onboard_moves, origin)
    diags.each do |d|
      onboard_moves.delete_if do |pos|
        diag_blocked_moves(d, origin).include?(pos)
      end
    end
  end

  def diag_blocked_moves(diag, origin)
    diag.blocked_moves(origin).map { |square| [square.file, square.rank] }
  end

  def winnowed_captures(position)
    origin = square(position)
    onboard_captures = origin.potential_captures.select do |c|
      squares.map(&:file).include?(c[0]) && squares.map(&:rank).include?(c[1])
    end

    delete_invalid_captures(onboard_captures, origin)

    onboard_captures
  end

  def delete_invalid_captures(onboard_captures, origin)
    delete_empties(onboard_captures)
    delete_row_blocked_captures(onboard_captures, origin)
    delete_col_blocked_captures(onboard_captures, origin)
    delete_diag_blocked_captures(onboard_captures, origin)
  end

  def delete_empties(onboard_captures)
    onboard_captures.delete_if { |pos| square(pos).empty? }
  end

  def delete_row_blocked_captures(onboard_captures, origin)
    rows.each do |row|
      onboard_captures.delete_if do |pos|
        row_blocked_captures(row, origin).include?(pos)
      end
    end
  end

  def row_blocked_captures(row, origin)
    row.blocked_captures(origin).map { |square| [square.file, square.rank] }
  end

  def delete_col_blocked_captures(onboard_captures, origin)
    cols.each do |col|
      onboard_captures.delete_if do |pos|
        col_blocked_captures(col, origin).include?(pos)
      end
    end
  end

  def col_blocked_captures(col, origin)
    col.blocked_captures(origin).map { |square| [square.file, square.rank] }
  end

  def delete_diag_blocked_captures(onboard_captures, origin)
    diags.each do |d|
      onboard_captures.delete_if do |pos|
        diag_blocked_captures(d, origin).include?(pos)
      end
    end
  end

  def diag_blocked_captures(diag, origin)
    diag.blocked_captures(origin).map { |square| [square.file, square.rank] }
  end

  def label_string
    Array.new(8).map.with_index do |_e, i|
      " #{('a'.ord + i).chr}"
    end.join("")
  end
end
