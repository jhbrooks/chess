# This class handles a Row of squares
class Row
  attr_reader :rank, :squares, :line_w

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
