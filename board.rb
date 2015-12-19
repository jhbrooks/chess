require_relative "./arrangement.rb"
require_relative "./square.rb"
require_relative "./piece.rb"
require_relative "./player.rb"

# This class handles a chess Board
class Board
  attr_reader :line_w, :squares, :rows, :cols, :diags

  def initialize(line_w)
    @line_w = line_w
    @squares = create_squares
    @rows = create_rows
    @cols = [1, 2, 3, 4, 5, 6, 7, 8]
    @diags = []
  end

  def to_s
    adjustment = (line_w / 2) + (label_string.length / 2)
    f_string = "#{label_string.rjust(adjustment)}\n"
    f_string << (rows.map(&:to_s).join("\n"))
    f_string << "\n\n"
  end

  private

  def create_squares
    squares = []
    squares << create_black_squares
    squares << create_empty_squares
    squares << create_white_squares
    squares.flatten
  end

  def create_black_squares
    black_squares = []
    black_squares << create_black_others
    black_squares << create_black_pawns
    black_squares.flatten
  end

  def create_black_others
    player = Player.new(:p2, :Black)
    pieces = [Rook.create(player), Knight.create(player),
              Bishop.create(player), Queen.create(player),
              King.create(player), Bishop.create(player),
              Knight.create(player), Rook.create(player)]
    pieces.map.with_index do |piece, i|
      file = i + 1
      Square.new(file, 8, piece)
    end
  end

  def create_black_pawns
    player = Player.new(:p2, :Black)
    black_pawns = []
    1.upto(8) do |file|
      black_pawns << Square.new(file, 7, Pawn.create(player))
    end
    black_pawns
  end

  def create_empty_squares
    empty_squares = []
    6.downto(3) do |rank|
      1.upto(8) do |file|
        empty_squares << Square.new(file, rank, nil)
      end
    end
    empty_squares
  end

  def create_white_squares
    white_squares = []
    white_squares << create_white_pawns
    white_squares << create_white_others
    white_squares.flatten
  end

  def create_white_pawns
    player = Player.new(:p1, :White)
    white_pawns = []
    1.upto(8) do |file|
      white_pawns << Square.new(file, 2, Pawn.create(player))
    end
    white_pawns
  end

  def create_white_others
    player = Player.new(:p1, :White)
    pieces = [Rook.create(player), Knight.create(player),
              Bishop.create(player), Queen.create(player),
              King.create(player), Bishop.create(player),
              Knight.create(player), Rook.create(player)]
    pieces.map.with_index do |piece, i|
      file = i + 1
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

  def label_string
    Array.new(cols.length).map.with_index do |_e, i|
      " #{('a'.ord + i).chr}"
    end.join("")
  end
end
