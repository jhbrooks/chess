require "spec_helper"

describe Piece do
  let(:piece) { Piece.new(:p1, :pawn) }
  let(:player) { Player.new(:p1, :White) }
  let(:true_piece) { Piece.new(player, :Pawn) }

  describe "#new" do
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

  describe "#to_s" do
    it "returns a formatted string representing the Bishop" do
      expect(bishop.to_s).to eq("White (p1) Bishop")
    end
  end
end

describe King do
  let(:player) { Player.new(:p1, :White) }
  let(:king) { King.create(player) }

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

  describe "#in_check" do
    it "returns false after initialization" do
      expect(king.in_check).to be(false)
    end
  end

  describe "#in_check=" do
    it "correctly sets the in_check attribute" do
      king.in_check = true
      expect(king.in_check).to be(true)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the King" do
      expect(king.to_s).to eq("White (p1) King")
    end
  end
end

describe Knight do
  let(:player) { Player.new(:p1, :White) }
  let(:knight) { Knight.create(player) }

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

  describe "#to_s" do
    it "returns a formatted string representing the Knight" do
      expect(knight.to_s).to eq("White (p1) Knight")
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

  describe "#to_s" do
    it "returns a formatted string representing the Pawn" do
      expect(pawn.to_s).to eq("White (p1) Pawn")
    end
  end
end

describe Queen do
  let(:player) { Player.new(:p1, :White) }
  let(:queen) { Queen.create(player) }

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

  describe "#to_s" do
    it "returns a formatted string representing the Queen" do
      expect(queen.to_s).to eq("White (p1) Queen")
    end
  end
end

describe Rook do
  let(:player) { Player.new(:p1, :White) }
  let(:rook) { Rook.create(player) }

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

  describe "#to_s" do
    it "returns a formatted string representing the Rook" do
      expect(rook.to_s).to eq("White (p1) Rook")
    end
  end
end
