# This class handles a Row of squares
class Row
  attr_reader :rank, :squares, :line_w

  def initialize(rank, squares, line_w)
    @rank = rank
    @squares = squares
    @line_w = line_w
  end

  def to_s
    adjustment = (line_w / 2) + (squares_string.length / 2)
    f_string = "#{rank} #{squares_string}".rjust(adjustment)
  end

  private

  def squares_string
    squares.map(&:to_s).join("")
  end
end
