require "spec_helper"

describe Piece do
  let(:piece) { Piece.new(:p1, :pawn) }
  let(:player) { Player.new(:p1, :White) }
  let(:true_piece) { Piece.new(player, :pawn) }

  describe ".new" do
    context "when given 2 arguments (player, type)" do
      it "returns a Piece object" do
        expect(piece).to be_an_instance_of(Piece)
      end
    end

    context "when given fewer than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Piece.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Piece.new(1, 2, 3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#player" do
    it "returns the correct player" do
      expect(piece.player).to eq(:p1)
    end
  end

  describe "#type" do
    it "returns the correct type" do
      expect(piece.type).to eq(:pawn)
    end
  end

  describe "#mark" do
    it "returns a mark representing the Piece" do
      expect(true_piece.mark).to eq("WP")
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Piece" do
      expect(piece.to_s).to eq("p1 pawn")
    end
  end
end

describe Bishop do
  let(:player) { Player.new(:p1, :White) }
  let(:bishop) { Bishop.create(player) }
  let(:bishop_pattern) do
    [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7]]
  end

  describe ".create" do
    context "when given 1 argument (player)" do
      it "returns a Bishop object" do
        expect(bishop).to be_an_instance_of(Bishop)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Bishop.create }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Bishop.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    it "returns a mark representing the Bishop" do
      expect(bishop.mark).to eq("WB")
    end
  end

  describe "#move_pattern" do
    it "returns a full range of diagonal position adjustments" do
      expect(bishop.move_pattern).to eq(bishop_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns a full range of diagonal position adjustments" do
      expect(bishop.capture_pattern).to eq(bishop_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Bishop" do
      expect(bishop.to_s).to eq("White (p1) bishop")
    end
  end
end

describe King do
  let(:player) { Player.new(:p1, :White) }
  let(:king) { King.create(player) }
  let(:king_pattern) do
    [[1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1]]
  end

  describe ".create" do
    context "when given 1 argument (player)" do
      it "returns a King object" do
        expect(king).to be_an_instance_of(King)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { King.create }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { King.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    it "returns a mark representing the King" do
      expect(king.mark).to eq("WK")
    end
  end

  describe "#unmoved" do
    it "returns true after initialization" do
      expect(king.unmoved).to be(true)
    end
  end

  describe "#unmoved=" do
    it "correctly sets the unmoved attribute" do
      king.unmoved = false
      expect(king.unmoved).to be(false)
    end
  end

  describe "#move_pattern" do
    it "returns single position adjustments in all directions" do
      expect(king.move_pattern).to eq(king_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns single position adjustments in all directions" do
      expect(king.capture_pattern).to eq(king_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the King" do
      expect(king.to_s).to eq("White (p1) king")
    end
  end
end

describe Knight do
  let(:player) { Player.new(:p1, :White) }
  let(:knight) { Knight.create(player) }
  let(:knight_pattern) do
    [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [2, -1], [-2, -1], [-2, 1]]
  end

  describe ".create" do
    context "when given 1 argument (player)" do
      it "returns a Knight object" do
        expect(knight).to be_an_instance_of(Knight)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Knight.create }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Knight.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    it "returns a mark representing the Knight" do
      expect(knight.mark).to eq("WN")
    end
  end

  describe "#move_pattern" do
    it "returns L-shaped adjustments (of both kinds) in all directions" do
      expect(knight.move_pattern).to eq(knight_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns L-shaped adjustments (of both kinds) in all directions" do
      expect(knight.capture_pattern).to eq(knight_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Knight" do
      expect(knight.to_s).to eq("White (p1) knight")
    end
  end
end

describe Pawn do
  let(:player) { Player.new(:p1, :White) }
  let(:pawn) { Pawn.create(player) }

  describe ".create" do
    context "when given 1 argument (player)" do
      it "returns a Pawn object" do
        expect(pawn).to be_an_instance_of(Pawn)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Pawn.create }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Pawn.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    it "returns a mark representing the Pawn" do
      expect(pawn.mark).to eq("WP")
    end
  end

  describe "#unmoved" do
    it "returns true after initialization" do
      expect(pawn.unmoved).to be(true)
    end
  end

  describe "#unmoved=" do
    it "correctly sets the unmoved attribute" do
      pawn.unmoved = false
      expect(pawn.unmoved).to be(false)
    end
  end

  describe "#move_pattern" do
    context "with a White Pawn" do
      context "which has not moved" do
        it "returns single and double upward position adjustments" do
          expect(pawn.move_pattern).to eq([[0, 1], [0, 2]])
        end
      end

      context "which has moved" do
        it "returns single upward position adjustments" do
          pawn.unmoved = false
          expect(pawn.move_pattern).to eq([[0, 1]])
        end
      end
    end

    context "with a Black Pawn" do
      let(:player) { Player.new(:p1, :Black) }
      let(:pawn) { Pawn.create(player) }

      context "which has not moved" do
        it "returns single and double downward position adjustments" do
          expect(pawn.move_pattern).to eq([[0, -1], [0, -2]])
        end
      end

      context "which has moved" do
        it "returns single downward position adjustments" do
          pawn.unmoved = false
          expect(pawn.move_pattern).to eq([[0, -1]])
        end
      end
    end
  end

  describe "#capture_pattern" do
    context "with a White Pawn" do
      it "returns single upward adjustments to the right and left" do
        expect(pawn.capture_pattern).to eq([[1, 1], [-1, 1]])
      end
    end

    context "with a Black Pawn" do
      let(:player) { Player.new(:p1, :Black) }
      let(:pawn) { Pawn.create(player) }

      it "returns single downward adjustments to the right and left" do
        expect(pawn.capture_pattern).to eq([[1, -1], [-1, -1]])
      end
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Pawn" do
      expect(pawn.to_s).to eq("White (p1) pawn")
    end
  end
end

describe Queen do
  let(:player) { Player.new(:p1, :White) }
  let(:queen) { Queen.create(player) }
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

  describe ".create" do
    context "when given 1 argument (player)" do
      it "returns a Queen object" do
        expect(queen).to be_an_instance_of(Queen)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Queen.create }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Queen.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    it "returns a mark representing the Queen" do
      expect(queen.mark).to eq("WQ")
    end
  end

  describe "#move_pattern" do
    it "returns a full range of position adjustments in all directions" do
      expect(queen.move_pattern).to eq(queen_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns a full range of position adjustments in all directions" do
      expect(queen.capture_pattern).to eq(queen_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Queen" do
      expect(queen.to_s).to eq("White (p1) queen")
    end
  end
end

describe Rook do
  let(:player) { Player.new(:p1, :White) }
  let(:rook) { Rook.create(player) }
  let(:rook_pattern) do
    [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
     [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7],
     [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
  end

  describe ".create" do
    context "when given 1 argument (player)" do
      it "returns a Rook object" do
        expect(rook).to be_an_instance_of(Rook)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Rook.create }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Rook.create(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#mark" do
    it "returns a mark representing the Rook" do
      expect(rook.mark).to eq("WR")
    end
  end

  describe "#unmoved" do
    it "returns true after initialization" do
      expect(rook.unmoved).to be(true)
    end
  end

  describe "#unmoved=" do
    it "correctly sets the unmoved attribute" do
      rook.unmoved = false
      expect(rook.unmoved).to be(false)
    end
  end

  describe "#move_pattern" do
    it "returns a full range of horizontal and vertical adjustments" do
      expect(rook.move_pattern).to eq(rook_pattern)
    end
  end

  describe "#capture_pattern" do
    it "returns a full range of horizontal and vertical adjustments" do
      expect(rook.capture_pattern).to eq(rook_pattern)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Rook" do
      expect(rook.to_s).to eq("White (p1) rook")
    end
  end
end
