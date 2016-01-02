require "spec_helper"

describe Arrangement do
  let(:arrangement) do
    Arrangement.new(%w(a1 b2))
  end
  let(:p1) { Player.new(:p1, :White) }
  let(:p2) { Player.new(:p2, :Black) }
  let(:w_piece) { Queen.create(p1) }
  let(:b_piece) { Queen.create(p2) }
  let(:true_arrangement) do
    Arrangement.new([Square.new(:a, 1, nil),
                     Square.new(:b, 1, b_piece),
                     Square.new(:c, 1, w_piece),
                     Square.new(:d, 1, nil),
                     Square.new(:e, 1, w_piece),
                     Square.new(:f, 1, b_piece),
                     Square.new(:g, 1, b_piece)])
  end
  let(:ta) { true_arrangement.squares }
  let(:origin) { ta[4] }
  let(:edge_origin) { ta[6] }

  describe ".new" do
    context "when given 1 argument (squares)" do
      it "returns an Arrangement object" do
        expect(arrangement).to be_an_instance_of(Arrangement)
      end
    end

    context "when given fewer than 1 argument" do
      it "raises an ArgumentError" do
        expect { Arrangement.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 1 argument" do
      it "raises an ArgumentError" do
        expect { Arrangement.new(1, 2) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#squares" do
    it "returns the correct collection of squares" do
      expect(arrangement.squares).to eq(%w(a1 b2))
    end
  end

  describe "#blocked_moves" do
    context "when given an origin square not within the Arrangement" do
      it "returns an empty array" do
        expect(true_arrangement.blocked_moves(:fake_origin)).to eq([])
      end
    end

    context "when given an origin square within the Arrangement" do
      it "returns an array of squares not accessible to the origin square" do
        expect(true_arrangement.blocked_moves(origin))
          .to eq([ta[0], ta[1], ta[2], ta[6], ta[5]])
      end

      it "includes the blocking squares" do
        expect(true_arrangement.blocked_moves(origin).include?(ta[5]))
          .to be(true)
      end
    end
  end

  describe "#blocked_captures" do
    context "when given an origin square not within the Arrangement" do
      it "returns an empty array" do
        expect(true_arrangement.blocked_captures(:fake_origin)).to eq([])
      end
    end

    context "when given an origin square within the Arrangement" do
      it "returns an array of squares not accessible to the origin square" do
        expect(true_arrangement.blocked_captures(origin))
          .to eq([ta[0], ta[1], ta[2], ta[6]])
      end

      context "with a blocking square with a friendly piece" do
        it "includes the blocking square" do
          expect(true_arrangement.blocked_captures(origin).include?(ta[2]))
            .to be(true)
        end
      end

      context "with a blocking square with an enemy piece" do
        it "does not include the blocking square" do
          expect(true_arrangement.blocked_captures(origin).include?(ta[5]))
            .to be(false)
        end
      end
    end

    context "when given an origin square on one edge of the Arrangement" do
      it "returns an array of squares not accessible to the origin square" do
        expect(true_arrangement.blocked_captures(edge_origin))
          .to eq([ta[0], ta[1], ta[2], ta[3], ta[4], ta[5]])
      end
    end
  end
end

describe Row do
  let(:row) do
    Row.new(1, %w(a1 b1), 10)
  end

  let(:player) { Player.new(:p1, :White) }
  let(:piece) { Piece.new(player, :pawn) }
  let(:true_row) do
    Row.new(1, [Square.new(:a, 1, piece), Square.new(:b, 1, piece)], 10)
  end

  let(:empty_row1) do
    Row.new(1, [Square.new(:a, 1, nil), Square.new(:b, 1, nil)], 10)
  end

  let(:empty_row2) do
    Row.new(2, [Square.new(:a, 2, nil), Square.new(:b, 2, nil)], 10)
  end

  describe "#new" do
    context "when given 3 arguments (rank, squares, line_w)" do
      it "returns a Row object" do
        expect(row).to be_an_instance_of(Row)
      end
    end

    context "when given fewer than 3 arguments" do
      it "raises an ArgumentError" do
        expect { Row.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 3 arguments" do
      it "raises an ArgumentError" do
        expect { Row.new(1, 2, 3, 4) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#rank" do
    it "returns the correct rank" do
      expect(row.rank).to eq(1)
    end
  end

  describe "#squares" do
    it "returns the correct collection of squares" do
      expect(row.squares).to eq(%w(a1 b1))
    end
  end

  describe "#line_w" do
    it "returns the correct line width" do
      expect(row.line_w).to eq(10)
    end
  end

  describe "#to_s" do
    context "when the Row is not empty" do
      it "returns a formatted string representing the Row" do
        expect(true_row.to_s).to eq(" 1 WPWP")
      end
    end

    context "when the Row is empty" do
      context "with an odd rank" do
        it "returns a formatted string leading with a black square" do
          expect(empty_row1.to_s).to eq(" 1 @@  ")
        end
      end

      context "with an even rank" do
        it "returns a formatted string leading with a white square" do
          expect(empty_row2.to_s).to eq(" 2   @@")
        end
      end
    end
  end
end

describe Column do
  let(:col) do
    Column.new(:a, %w(a1 a2))
  end

  describe "#new" do
    context "when given 2 arguments (file, squares)" do
      it "returns a Column object" do
        expect(col).to be_an_instance_of(Column)
      end
    end

    context "when given fewer than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Column.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Column.new(1, 2, 3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#file" do
    it "returns the correct file" do
      expect(col.file).to eq(:a)
    end
  end

  describe "#squares" do
    it "returns the correct collection of squares" do
      expect(col.squares).to eq(%w(a1 a2))
    end
  end
end
