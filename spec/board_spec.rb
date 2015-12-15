require "spec_helper"

describe Board do
  let(:board) { Board.new(80) }

  describe "#new" do
    context "when given 1 argument (line_w)" do
      it "returns a Board object" do
        expect(board).to be_an_instance_of(Board)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Board.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Board.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#line_w" do
    it "returns the correct line width" do
      expect(board.line_w).to eq(80)
    end
  end

  describe "#squares" do
    it "returns the correct collection of squares" do
      expect(board.squares).to eq([])
    end
  end

  describe "#rows" do
    it "returns the correct collection of rows" do
      expect(board.rows).to eq([])
    end
  end

  describe "#cols" do
    it "returns the correct collection of columns" do
      expect(board.cols).to eq([])
    end
  end

  describe "#diags" do
    it "returns the correct collection of diagonals" do
      expect(board.diags).to eq([])
    end
  end
end
