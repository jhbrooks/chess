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

  def label_string
    Array.new(8).map.with_index do |_e, i|
      " #{('a'.ord + i).chr}"
    end.join("")
  end
end
