# This class handles a Row of squares
class Row
  attr_reader :rank, :squares, :line_w

  def initialize(rank, squares, line_w)
    @rank = rank
    @squares = squares
    @line_w = line_w
  end
end
