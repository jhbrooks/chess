# This class handles a Square on a chess board
class Square
  attr_reader :file, :rank, :piece

  def initialize(file, rank, piece)
    @file = file
    @rank = rank
    @piece = piece
  end

  def to_s
    "#{piece}"
  end
end
