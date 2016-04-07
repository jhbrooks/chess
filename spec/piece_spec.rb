require "spec_helper"

describe Piece do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_piece) { Piece.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_piece) { Piece.new(p2) }

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a Piece object" do
        expect(white_piece).to be_an_instance_of(Piece)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Piece.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Piece.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#player" do
    it "returns the correct player" do
      expect(white_piece.player).to eq(p1)
    end
  end

  describe "#to_s" do
    context "with a White player piece" do
      it "returns a formatted string representing the Piece" do
        expect(white_piece.to_s).to eq("White (p1) piece")
      end
    end

    context "with a Black player piece" do
      it "returns a formatted string representing the Piece" do
        expect(black_piece.to_s).to eq("Black (p2) piece")
      end
    end
  end
end

describe Bishop do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_bishop) { Bishop.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_bishop) { Bishop.new(p2) }
  let(:bishop_pattern) do
    [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]
  end

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a Bishop object" do
        expect(white_bishop).to be_an_instance_of(Bishop)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Bishop.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Bishop.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    context "with a White player piece" do
      it "returns a mark representing the Bishop" do
        expect(white_bishop.mark).to eq("♗")
      end
    end

    context "with a Black player piece" do
      it "returns a mark representing the Bishop" do
        expect(black_bishop.mark).to eq("♝")
      end
    end
  end

  describe "#move_pattern" do
    it "returns a full range of diagonal position adjustments" do
      expect(white_bishop.move_pattern).to eq(bishop_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns a full range of diagonal position adjustments" do
      expect(white_bishop.capture_pattern).to eq(bishop_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Bishop" do
      expect(white_bishop.to_s).to eq("White (p1) bishop")
    end
  end
end

describe King do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_king) { King.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_king) { King.new(p2) }
  let(:king_pattern) do
    [[1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1]]
  end

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a King object" do
        expect(white_king).to be_an_instance_of(King)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { King.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { King.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    context "with a White player piece" do
      it "returns a mark representing the King" do
        expect(white_king.mark).to eq("♔")
      end
    end

    context "with a Black player piece" do
      it "returns a mark representing the King" do
        expect(black_king.mark).to eq("♚")
      end
    end
  end

  describe "#unmoved" do
    it "returns true after initialization" do
      expect(white_king.unmoved).to be(true)
    end
  end

  describe "#unmoved=" do
    it "correctly sets the unmoved attribute" do
      white_king.unmoved = false
      expect(white_king.unmoved).to be(false)
    end
  end

  describe "#move_pattern" do
    it "returns single position adjustments in all directions" do
      expect(white_king.move_pattern).to eq(king_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns single position adjustments in all directions" do
      expect(white_king.capture_pattern).to eq(king_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the King" do
      expect(white_king.to_s).to eq("White (p1) king")
    end
  end
end

describe Knight do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_knight) { Knight.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_knight) { Knight.new(p2) }
  let(:knight_pattern) do
    [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [2, -1], [-2, -1], [-2, 1]]
  end

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a Knight object" do
        expect(white_knight).to be_an_instance_of(Knight)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Knight.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Knight.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    context "with a White player piece" do
      it "returns a mark representing the Knight" do
        expect(white_knight.mark).to eq("♘")
      end
    end

    context "with a Black player piece" do
      it "returns a mark representing the Knight" do
        expect(black_knight.mark).to eq("♞")
      end
    end
  end

  describe "#move_pattern" do
    it "returns L-shaped adjustments (of both kinds) in all directions" do
      expect(white_knight.move_pattern).to eq(knight_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns L-shaped adjustments (of both kinds) in all directions" do
      expect(white_knight.capture_pattern).to eq(knight_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Knight" do
      expect(white_knight.to_s).to eq("White (p1) knight")
    end
  end
end

describe Pawn do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_pawn) { Pawn.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_pawn) { Pawn.new(p2) }

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a Pawn object" do
        expect(white_pawn).to be_an_instance_of(Pawn)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Pawn.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Pawn.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    context "with a White player piece" do
      it "returns a mark representing the Pawn" do
        expect(white_pawn.mark).to eq("♙")
      end
    end

    context "with a Black player piece" do
      it "returns a mark representing the Pawn" do
        expect(black_pawn.mark).to eq("♟")
      end
    end
  end

  describe "#unmoved" do
    it "returns true after initialization" do
      expect(white_pawn.unmoved).to be(true)
    end
  end

  describe "#unmoved=" do
    it "correctly sets the unmoved attribute" do
      white_pawn.unmoved = false
      expect(white_pawn.unmoved).to be(false)
    end
  end

  describe "#move_pattern" do
    context "with a White Pawn" do
      context "which has not moved" do
        it "returns single and double upward position adjustments" do
          expect(white_pawn.move_pattern).to eq([[0, 1], [0, 2]])
        end
      end

      context "which has moved" do
        it "returns single upward position adjustments" do
          white_pawn.unmoved = false
          expect(white_pawn.move_pattern).to eq([[0, 1]])
        end
      end
    end

    context "with a Black Pawn" do
      context "which has not moved" do
        it "returns single and double downward position adjustments" do
          expect(black_pawn.move_pattern).to eq([[0, -1], [0, -2]])
        end
      end

      context "which has moved" do
        it "returns single downward position adjustments" do
          black_pawn.unmoved = false
          expect(black_pawn.move_pattern).to eq([[0, -1]])
        end
      end
    end
  end

  describe "#capture_pattern" do
    context "with a White Pawn" do
      it "returns single upward adjustments to the right and left" do
        expect(white_pawn.capture_pattern).to eq([[1, 1], [-1, 1]])
      end
    end

    context "with a Black Pawn" do
      it "returns single downward adjustments to the right and left" do
        expect(black_pawn.capture_pattern).to eq([[1, -1], [-1, -1]])
      end
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Pawn" do
      expect(white_pawn.to_s).to eq("White (p1) pawn")
    end
  end
end

describe Queen do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_queen) { Queen.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_queen) { Queen.new(p2) }
  let(:queen_pattern) do
    bp = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
          [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
          [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
          [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]
    rp = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
          [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
          [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
    bp + rp
  end

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a Queen object" do
        expect(white_queen).to be_an_instance_of(Queen)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Queen.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Queen.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    context "with a White player piece" do
      it "returns a mark representing the Queen" do
        expect(white_queen.mark).to eq("♕")
      end
    end

    context "with a Black player piece" do
      it "returns a mark representing the Queen" do
        expect(black_queen.mark).to eq("♛")
      end
    end
  end

  describe "#move_pattern" do
    it "returns a full range of position adjustments in all directions" do
      expect(white_queen.move_pattern).to eq(queen_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns a full range of position adjustments in all directions" do
      expect(white_queen.capture_pattern).to eq(queen_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Queen" do
      expect(white_queen.to_s).to eq("White (p1) queen")
    end
  end
end

describe Rook do
  let(:p1) { Player.new(:p1, :White) }
  let(:white_rook) { Rook.new(p1) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:black_rook) { Rook.new(p2) }
  let(:rook_pattern) do
    [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
     [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
     [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
  end

  describe ".new" do
    context "when given 1 argument (player)" do
      it "returns a Rook object" do
        expect(white_rook).to be_an_instance_of(Rook)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Rook.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Rook.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    context "with a White player piece" do
      it "returns a mark representing the Rook" do
        expect(white_rook.mark).to eq("♖")
      end
    end

    context "with a Black player piece" do
      it "returns a mark representing the Rook" do
        expect(black_rook.mark).to eq("♜")
      end
    end
  end

  describe "#unmoved" do
    it "returns true after initialization" do
      expect(white_rook.unmoved).to be(true)
    end
  end

  describe "#unmoved=" do
    it "correctly sets the unmoved attribute" do
      white_rook.unmoved = false
      expect(white_rook.unmoved).to be(false)
    end
  end

  describe "#move_pattern" do
    it "returns a full range of horizontal and vertical adjustments" do
      expect(white_rook.move_pattern).to eq(rook_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns a full range of horizontal and vertical adjustments" do
      expect(white_rook.capture_pattern).to eq(rook_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Rook" do
      expect(white_rook.to_s).to eq("White (p1) rook")
    end
  end
end
