# This class handles Squares on a chess board
class Square
  attr_reader :file, :rank
  attr_accessor :piece

  def initialize(file, rank, piece)
    @file = file
    @rank = rank
    @piece = piece
  end

  def pos
    [file, rank]
  end

  def empty?
    piece.nil?
  end

  # Requires piece to have the #move_pattern method
  def potential_moves
    piece.move_pattern.map do |f, r|
      [(f + file.to_s.ord).chr.to_sym, r + rank]
    end
  end

  # Requires piece to have the #capture_pattern method
  def potential_captures
    piece.capture_pattern.map do |f, r|
      [(f + file.to_s.ord).chr.to_sym, r + rank]
    end
  end

  # Requires piece to have the #mark method
  def to_s
    "#{piece.mark}"
  end
end
