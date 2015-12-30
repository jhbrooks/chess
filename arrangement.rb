# This class handles Arrangements of squares on a chess board
class Arrangement
  attr_reader :squares

  def initialize(squares)
    @squares = squares
  end

  # Requires all squares to have the #empty? method
  def blocked_moves(origin)
    return [] unless squares.include?(origin)
    before_blocked_squares(origin) + after_blocked_squares(origin)
  end

  # Requires all squares to have the #empty? method.
  # Requires some non-empty squares and origin to have a piece with a player.
  def blocked_captures(origin)
    return [] unless squares.include?(origin)

    blocked_squares = before_blocked_squares(origin)
    blocked_squares = blocked_squares_minus_captures(blocked_squares, origin)

    blocked_squares += after_blocked_squares(origin)
    blocked_squares_minus_captures(blocked_squares, origin)
  end

  private

  # Requires all squares to have the #empty? method
  def before_blocked_squares(origin)
    blocked_squares = []
    available_squares = []
    squares.take_while { |square| square != origin }.each do |square|
      available_squares << square
      unless square.empty?
        blocked_squares += available_squares
        available_squares = []
      end
    end
    blocked_squares
  end

  # Requires all squares to have the #empty? method
  def after_blocked_squares(origin)
    blocked_squares = []
    available_squares = []
    squares.reverse.take_while { |square| square != origin }.each do |square|
      available_squares << square
      unless square.empty?
        blocked_squares += available_squares
        available_squares = []
      end
    end
    blocked_squares
  end

  # Requires all squares to have the #empty? method.
  # Requires some non-empty squares and origin to have a piece with a player.
  def blocked_squares_minus_captures(blocked_squares, origin)
    return [] if blocked_squares.empty?
    unless blocked_squares[-1].piece.player == origin.piece.player
      blocked_squares = blocked_squares[0..-2]
    end
    blocked_squares
  end
end

# This class handles Rows of squares on a chess board
class Row < Arrangement
  attr_reader :rank, :line_w

  def initialize(rank, squares, line_w)
    @rank = rank
    @squares = squares
    @line_w = line_w
  end

  # Requires all squares to have the #empty? method
  def to_s
    adjustment = (line_w / 2) + (squares_string.length / 2)
    "#{rank} #{squares_string}".rjust(adjustment)
  end

  private

  # Requires all squares to have the #empty? method
  def squares_string
    squares.map.with_index do |square, index|
      if square.empty?
        square_color(index)
      else
        "#{square}"
      end
    end.join("")
  end

  def square_color(index)
    if rank.odd?
      index.even? ? "@@" : "  "
    else
      index.even? ? "  " : "@@"
    end
  end
end

# This class handles Columns of squares on a chess board
class Column < Arrangement
  attr_reader :file

  def initialize(file, squares)
    @file = file
    @squares = squares
  end
end
