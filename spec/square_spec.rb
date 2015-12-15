require "spec_helper"

describe Square do
  let(:square) { Square.new(:a, 1, :piece) }

  describe "#new" do
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
      expect(square.piece).to eq(:piece)
    end
  end

  describe "#to_s" do
    it "returns the Square's piece as a string" do
      expect(square.to_s).to eq("piece")
    end
  end
end
