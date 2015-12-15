require "spec_helper"

describe Board do
  let(:board) { Board.new(10) }

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
      expect(board.line_w).to eq(10)
    end
  end

  describe "#squares" do
    it "returns the correct collection of squares" do
      expect(board.squares).to eq([])
    end
  end

  describe "#rows" do
    it "returns the correct collection of rows" do
      expect(board.rows).to eq(%w(2a2b 1a1b))
    end
  end

  describe "#cols" do
    it "returns the correct collection of columns" do
      expect(board.cols).to eq([1, 2])
    end
  end

  describe "#diags" do
    it "returns the correct collection of diagonals" do
      expect(board.diags).to eq([])
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Board" do
      expect(board.to_s).to eq("    a b\n"\
                               "2a2b\n"\
                               "1a1b\n\n")
    end
  end
end
