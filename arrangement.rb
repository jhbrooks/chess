# This class handles Arrangements of squares on a chess board
class Arrangement
  attr_reader :squares

  def initialize(squares)
    @squares = squares
  end

  # Requires all squares to have the #empty? method
  def relevant_blocked_squares(origin)
    return [] unless squares.include?(origin)
    blocked_squares(squares, origin) + blocked_squares(squares.reverse, origin)
  end

  private

  # Requires all squares to have the #empty? method
  def blocked_squares(sqrs, origin)
    blocked_squares = []
    available_squares = []
    sqrs.take_while { |s| s != origin }.each do |s|
      unless s.empty?
        blocked_squares += available_squares
        available_squares = []
      end
      available_squares << s
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
