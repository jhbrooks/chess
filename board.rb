# This class handles a chess Board
class Board
  attr_reader :line_w, :squares, :rows, :cols, :diags

  def initialize(line_w)
    @line_w = line_w
    @squares = []
    @rows = %w(2a2b 1a1b)
    @cols = [1, 2]
    @diags = []
  end

  def to_s
    adjustment = (line_w / 2) + (label_string.length / 2)
    f_string = "#{label_string.rjust(adjustment)}\n"
    f_string << (rows.map(&:to_s).join("\n"))
    f_string << "\n\n"
  end

  private

  def label_string
    Array.new(cols.length).map.with_index do |_e, i|
      " #{('a'.ord + i).chr}"
    end.join("")
  end
end
