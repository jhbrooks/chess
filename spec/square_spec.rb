require "spec_helper"

describe Square do
  let(:player) { Player.new(:p1, :White) }
  let(:piece) { Pawn.new(player) }
  let(:square) { Square.new(:a, 1, piece) }
  let(:empty_square) { Square.new(:a, 1, nil) }

  describe ".new" do
    context "when given 3 arguments (file, rank, piece)" do
      it "returns a Square object" do
        expect(square).to be_an_instance_of(Square)
      end
    end

    context "when given fewer than 3 arguments" do
      it "raises an ArgumentError" do
        expect { Square.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 3 arguments" do
      it "raises an ArgumentError" do
        expect { Square.new(1, 2, 3, 4) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#file" do
    it "returns the correct file" do
      expect(square.file).to eq(:a)
    end
  end

  describe "#rank" do
    it "returns the correct rank" do
      expect(square.rank).to eq(1)
    end
  end

  describe "#piece" do
    it "returns the correct piece" do
      expect(square.piece).to eq(piece)
    end
  end

  describe "#piece=" do
    it "correctly sets a new piece" do
      square.piece = nil
      expect(square.piece).to be(nil)
    end
  end

  describe "#pos" do
    it "returns an array containing the Square's file and rank" do
      expect(square.pos).to eq([:a, 1])
    end
  end

  describe "#empty?" do
    context "when the Square has a piece" do
      it "returns false" do
        expect(square.empty?).to be(false)
      end
    end

    context "when the Square does not have a piece (piece is nil)" do
      it "returns true" do
        expect(empty_square.empty?).to be(true)
      end
    end
  end

  describe "#potential_moves" do
    it "returns move positions based on the Square and its piece" do
      expect(square.potential_moves).to eq([[:a, 2], [:a, 3]])
    end
  end

  describe "#potential_captures" do
    it "returns capture positions based on the Square and its piece" do
      expect(square.potential_captures).to eq([[:b, 2], [:`, 2]])
    end
  end

  describe "#to_s" do
    it "returns the Square's piece's mark as a string" do
      expect(square.to_s).to eq("♙")
    end
  end
end
