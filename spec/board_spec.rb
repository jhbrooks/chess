require "spec_helper"

describe Board do
  let(:players) { [Player.new(:p1, :White), Player.new(:p2, :Black)] }
  let(:board) { Board.new(players, 24) }

  describe "#new" do
    context "when given 2 arguments (players, line_w)" do
      it "returns a Board object" do
        expect(board).to be_an_instance_of(Board)
      end
    end

    context "when given fewer than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Board.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Board.new(1, 2, 3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#line_w" do
    it "returns the correct line width" do
      expect(board.line_w).to eq(24)
    end
  end

  describe "#squares" do
    it "returns a collection of squares with the correct length" do
      expect(board.squares.length).to eq(64)
    end
  end

  describe "#rows" do
    it "returns a collection of rows with the correct length" do
      expect(board.rows.length).to eq(8)
    end
  end

  describe "#cols" do
    it "returns a collection of columns with the correct length" do
      expect(board.cols.length).to eq(8)
    end
  end

  describe "#diags" do
    it "returns a collection of diagonals with the correct length" do
      expect(board.diags.length).to eq(30)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Board" do
      expect(board.to_s).to eq("     a b c d e f g h\n"\
                               "  8 BRBNBBBQBKBBBNBR\n"\
                               "  7 BPBPBPBPBPBPBPBP\n"\
                               "  6   @@  @@  @@  @@\n"\
                               "  5 @@  @@  @@  @@  \n"\
                               "  4   @@  @@  @@  @@\n"\
                               "  3 @@  @@  @@  @@  \n"\
                               "  2 WPWPWPWPWPWPWPWP\n"\
                               "  1 WRWNWBWQWKWBWNWR\n\n")
    end
  end
end
