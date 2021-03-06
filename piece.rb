# This extends the built-in Array class to help us build Piece move patterns
class Array
  def minus_r
    [self[0], -self[1]]
  end

  def minus_f_r
    [-self[0], -self[1]]
  end

  def minus_f
    [-self[0], self[1]]
  end
end

# This class handles Pieces in a game of chess
class Piece
  attr_reader :player
  attr_accessor :unmoved

  def initialize(player)
    @player = player
    @unmoved = true
  end

  def move_pattern
  end

  def capture_pattern
    move_pattern
  end

  def to_s
    "#{player} #{self.class.to_s.downcase}"
  end
end

# This class handles Bishops
class Bishop < Piece
  # Requires player to have the #color method
  # Expects player colors to be :White and :Black
  def mark
    if player.color == :White
      "♗"
    else
      "♝"
    end
  end

  def move_pattern
    base_adjs = Array.new(7).map.with_index { |_e, i| [i + 1, i + 1] }
    base_adjs.+(base_adjs.map(&:minus_r))
      .+(base_adjs.map(&:minus_f_r)).+(base_adjs.map(&:minus_f))
  end
end

# This class handles Kings
class King < Piece
  def mark
    # Requires player to have the #color method
    # Expects player colors to be :White and :Black
    if player.color == :White
      "♔"
    else
      "♚"
    end
  end

  def move_pattern
    [[1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1]]
  end
end

# This class handles Knights
class Knight < Piece
  # Requires player to have the #color method
  # Expects player colors to be :White and :Black
  def mark
    if player.color == :White
      "♘"
    else
      "♞"
    end
  end

  def move_pattern
    [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [2, -1], [-2, -1], [-2, 1]]
  end
end

# This class handles Pawns
class Pawn < Piece
  # Requires player to have the #color method
  # Expects player colors to be :White and :Black
  def mark
    if player.color == :White
      "♙"
    else
      "♟"
    end
  end

  # Requires player to have the #color method
  # Expects player colors to be :White and :Black
  def move_pattern
    return player.color == :White ? [[0, 1]] : [[0, -1]] unless unmoved
    player.color == :White ? [[0, 1], [0, 2]] : [[0, -1], [0, -2]]
  end

  # Requires player to have the #color method.
  # Expects player colors to be :White and :Black
  def capture_pattern
    player.color == :White ? [[1, 1], [-1, 1]] : [[1, -1], [-1, -1]]
  end
end

# This class handles Queens
class Queen < Piece
  # Requires player to have the #color method
  # Expects player colors to be :White and :Black
  def mark
    if player.color == :White
      "♕"
    else
      "♛"
    end
  end

  def move_pattern
    bishop_pattern + rook_pattern
  end

  private

  def bishop_pattern
    base_adjs = Array.new(7).map.with_index { |_e, i| [i + 1, i + 1] }
    base_adjs.+(base_adjs.map(&:minus_r))
      .+(base_adjs.map(&:minus_f_r)).+(base_adjs.map(&:minus_f))
  end

  def rook_pattern
    h_adjs = Array.new(7).map.with_index { |_e, i| [i + 1, 0] }
    v_adjs = Array.new(7).map.with_index { |_e, i| [0, -(i + 1)] }
    h_adjs + v_adjs + h_adjs.map(&:minus_f) + v_adjs.map(&:minus_r)
  end
end

# This class handles Rooks
class Rook < Piece
  # Requires player to have the #color method
  # Expects player colors to be :White and :Black
  def mark
    if player.color == :White
      "♖"
    else
      "♜"
    end
  end

  def move_pattern
    h_adjs = Array.new(7).map.with_index { |_e, i| [i + 1, 0] }
    v_adjs = Array.new(7).map.with_index { |_e, i| [0, -(i + 1)] }
    h_adjs + v_adjs + h_adjs.map(&:minus_f) + v_adjs.map(&:minus_r)
  end
end
