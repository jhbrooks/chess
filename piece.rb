# This class handles Pieces in a game of chess
class Piece
  attr_reader :player, :type

  def initialize(player, type)
    @player = player
    @type = type
  end

  # Requires player to have the #mark method
  def mark
    type_mark = "#{type}"[0]
    "#{player.mark}#{type_mark}"
  end

  def to_s
    "#{player} #{type}"
  end
end

# This class handles Bishops
class Bishop < Piece
  def self.create(player)
    new(player, :Bishop)
  end
end

# This class handles Kings
class King < Piece
  def self.create(player)
    new(player, :King)
  end
end

# This class handles Knights
class Knight < Piece
  def self.create(player)
    new(player, :Knight)
  end

  def mark
    type_mark = "#{type}"[1].upcase
    "#{player.mark}#{type_mark}"
  end
end

# This class handles Pawns
class Pawn < Piece
  def self.create(player)
    new(player, :Pawn)
  end
end

# This class handles Queens
class Queen < Piece
  def self.create(player)
    new(player, :Queen)
  end
end

# This class handles Rooks
class Rook < Piece
  def self.create(player)
    new(player, :Rook)
  end
end
