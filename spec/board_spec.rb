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
    context "returns a collection of squares such that" do
      it "the collection is of the correct length" do
        expect(board.squares.length).to eq(64)
      end

      it "each square is a Square object" do
        expect(board.squares.all? do |square|
          square.is_a?(Square)
        end).to be(true)
      end

      it "squares at the beginning contain Black pieces" do
        expect(board.squares[0..15].all? do |square|
          square.piece.player.color == :Black
        end).to be(true)
      end

      it "squares in the middle are empty" do
        expect(board.squares[16..47].all?(&:empty?)).to be(true)
      end

      it "squares at the end contain White pieces" do
        expect(board.squares[48..63].all? do |square|
          square.piece.player.color == :White
        end).to be(true)
      end
    end
  end

  describe "#rows" do
    context "returns a collection of rows such that" do
      it "the collection is of the correct length" do
        expect(board.rows.length).to eq(8)
      end

      it "each row is a Row object" do
        expect(board.rows.all? do |row|
          row.is_a?(Row)
        end).to be(true)
      end

      it "each row has a collection of squares of the correct length" do
        expect(board.rows.all? do |row|
          row.squares.length == 8
        end).to be(true)
      end
    end
  end

  describe "#cols" do
    context "returns a collection of columns such that" do
      it "the collection is of the correct length" do
        expect(board.cols.length).to eq(8)
      end

      it "each column is a Column object" do
        expect(board.cols.all? do |col|
          col.is_a?(Column)
        end).to be(true)
      end

      it "each column has a collection of squares of the correct length" do
        expect(board.cols.all? do |col|
          col.squares.length == 8
        end).to be(true)
      end
    end
  end

  describe "#diags" do
    context "returns a collection of diagonals such that" do
      it "the collection is of the correct length" do
        expect(board.diags.length).to eq(30)
      end

      it "each diagonal is an Arrangement object" do
        expect(board.diags.all? do |diag|
          diag.is_a?(Arrangement)
        end).to be(true)
      end

      it "the first up-diagonal's collection of squares is of length 1" do
        expect(board.diags[0].squares.length).to eq(1)
      end

      it "the middle up-diagonal's collection of squares is of length 8" do
        expect(board.diags[7].squares.length).to eq(8)
      end

      it "the last up-diagonal's collection of squares is of length 1" do
        expect(board.diags[14].squares.length).to eq(1)
      end

      it "the first down-diagonal's collection of squares is of length 1" do
        expect(board.diags[15].squares.length).to eq(1)
      end

      it "the middle down-diagonal's collection of squares is of length 8" do
        expect(board.diags[22].squares.length).to eq(8)
      end

      it "the last down-diagonal's collection of squares is of length 1" do
        expect(board.diags[29].squares.length).to eq(1)
      end
    end
  end

  describe "#make_move" do
    context "when the move is not legal" do
      it "returns false" do
        expect(board.make_move([:d, 1], [:d, 7])).to be(false)
      end

      it "leaves the target square's piece unchanged" do
        board.make_move([:d, 1], [:d, 7])
        expect(board.rows[1].squares[3].piece).to be_an_instance_of(Pawn)
      end

      it "leaves the origin square's piece unchanged" do
        board.make_move([:d, 1], [:d, 7])
        expect(board.rows[7].squares[3].piece).to be_an_instance_of(Queen)
      end
    end

    context "when the move is legal" do
      it "returns true" do
        expect(board.make_move([:d, 2], [:d, 4])).to be(true)
      end

      it "replaces the target square's piece with the origin square's" do
        board.make_move([:d, 2], [:d, 4])
        expect(board.rows[4].squares[3].piece).to be_an_instance_of(Pawn)
      end

      it "leaves the origin square empty" do
        board.make_move([:d, 2], [:d, 4])
        expect(board.rows[6].squares[3].empty?).to be(true)
      end
    end
  end

  describe "#square" do
    context "when the given position matches an onboard square" do
      it "returns a truthy value" do
        expect(board.square([:a, 1])).to be_truthy
      end

      it "returns a Square object" do
        expect(board.square([:a, 1])).to be_an_instance_of(Square)
      end
    end

    context "when the given position matches an off-board square" do
      it "returns a falsey value" do
        expect(board.square([:a, 0])).to be_falsey
      end
    end
  end

  describe "#legal_moves" do
    context "returns a collection of moves (and captures) such that" do
      it "no off-board moves are included" do
        expect(board.legal_moves([:d, 1]).include?([:d, 0])).to be(false)
      end

      it "no captures of friendly pieces are included" do
        expect(board.legal_moves([:d, 1]).include?([:e, 1])).to be(false)
      end

      it "captures of enemy pieces (if available) are included" do
        board.make_move([:d, 2], [:d, 4])
        board.make_move([:d, 4], [:d, 5])
        board.make_move([:d, 5], [:d, 6])
        expect(board.legal_moves([:d, 6]).include?([:e, 7])).to be(true)
      end

      it "no moves past pieces in the same row are included" do
        board.make_move([:d, 2], [:d, 4])
        board.make_move([:d, 4], [:d, 5])
        board.make_move([:d, 5], [:d, 6])
        board.make_move([:d, 6], [:e, 7])

        board.make_move([:e, 2], [:e, 3])
        board.make_move([:d, 1], [:d, 3])
        expect(board.legal_moves([:d, 3]).include?([:f, 3])).to be(false)
      end

      it "no moves past pieces in the same column are included" do
        expect(board.legal_moves([:d, 1]).include?([:d, 3])).to be(false)
      end

      it "no moves past pieces in the same diagonal are included" do
        expect(board.legal_moves([:d, 1]).include?([:f, 3])).to be(false)
      end
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
