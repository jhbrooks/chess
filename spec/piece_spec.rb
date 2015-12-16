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
