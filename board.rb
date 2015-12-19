require_relative "./arrangement.rb"
require_relative "./square.rb"
require_relative "./piece.rb"

# This class handles a chess Board
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
    f_string << (rows.map(&:to_s).join("\n"))
    f_string << "\n\n"
  end

  private

  def create_squares(players)
    squares = []
    squares << create_black_squares(players[1])
    squares << create_empty_squares
    squares << create_white_squares(players[0])
    squares.flatten
  end

  def create_black_squares(player)
    black_squares = []
    black_squares << create_black_others(player)
    black_squares << create_black_pawns(player)
    black_squares.flatten
  end

  def create_black_others(player)
    pieces = [Rook.create(player), Knight.create(player),
              Bishop.create(player), Queen.create(player),
              King.create(player), Bishop.create(player),
              Knight.create(player), Rook.create(player)]
    pieces.map.with_index do |piece, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 8, piece)
    end
  end

  def create_black_pawns(player)
    black_pawns = []
    8.times do |i|
      file = ("a".ord + i).chr.to_sym
      black_pawns << Square.new(file, 7, Pawn.create(player))
    end
    black_pawns
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
    white_squares = []
    white_squares << create_white_pawns(player)
    white_squares << create_white_others(player)
    white_squares.flatten
  end

  def create_white_pawns(player)
    white_pawns = []
    8.times do |i|
      file = ("a".ord + i).chr.to_sym
      white_pawns << Square.new(file, 2, Pawn.create(player))
    end
    white_pawns
  end

  def create_white_others(player)
    pieces = [Rook.create(player), Knight.create(player),
              Bishop.create(player), Queen.create(player),
              King.create(player), Bishop.create(player),
              Knight.create(player), Rook.create(player)]
    pieces.map.with_index do |piece, i|
      file = ("a".ord + i).chr.to_sym
      Square.new(file, 1, piece)
    end
  end

  def create_rows
    Array.new(8).map.with_index do |_e, i|
      rank = 8 - i
      target_squares = squares.select { |square| square.rank == rank }
      Row.new(rank, target_squares, line_w)
    end
  end

  def create_columns
    Array.new(8).map.with_index do |_e, i|
      file = ("a".ord + i).chr.to_sym
      target_squares = squares.select { |square| square.file == file }
      Column.new(file, target_squares)
    end
  end

  def create_diagonals
    diagonals = []
    diagonals << create_up_diagonals
    diagonals << create_down_diagonals
    diagonals.flatten
  end

  def create_up_diagonals
    Array.new(15).map.with_index do |_e, i|
      target_squares = squares.select do |square|
        (square.file.to_s.ord - "a".ord) + (8 - square.rank) == i
      end
      Arrangement.new(target_squares)
    end
  end

  def create_down_diagonals
    Array.new(15).map.with_index do |_e, i|
      target_squares = squares.select do |square|
        (square.file.to_s.ord - "a".ord) + square.rank == i + 1
      end
      Arrangement.new(target_squares)
    end
  end

  def label_string
    Array.new(cols.length).map.with_index do |_e, i|
      " #{('a'.ord + i).chr}"
    end.join("")
  end
end
