require "spec_helper"

describe Piece do
  let(:piece) { Piece.new(:p1, :pawn) }

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
end
