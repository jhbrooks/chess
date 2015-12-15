# This class handles a chess Board
class Board
  attr_reader :line_w, :squares, :rows, :cols, :diags

  def initialize(line_w)
    @line_w = line_w
    @squares = []
    @rows = []
    @cols = []
    @diags = []
  end
end
