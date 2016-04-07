require "spec_helper"

describe Arrangement do
  let(:arrangement) { Arrangement.new(%w(a1 b2)) }

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

  describe "#relevant_blocked_squares" do
    let(:misc_arrangement) do
      Arrangement.new([Square.new(:a, 1, nil),
                       Square.new(:b, 1, :p),
                       Square.new(:c, 1, :p),
                       Square.new(:d, 1, nil),
                       Square.new(:e, 1, :p),
                       Square.new(:f, 1, :p),
                       Square.new(:g, 1, :p)])
    end
    let(:ma_s) { misc_arrangement.squares }
    let(:ma_orig) { ma_s[4] }

    context "when given an origin square not within the Arrangement" do
      it "returns an empty array" do
        expect(misc_arrangement.relevant_blocked_squares(:fake_origin))
          .to eq([])
      end
    end

    context "when given an origin square within the Arrangement" do
      let(:beg_orig_arrangement) do
        Arrangement.new([Square.new(:c, 1, :p),
                         Square.new(:d, 1, nil),
                         Square.new(:e, 1, :p),
                         Square.new(:f, 1, :p),
                         Square.new(:g, 1, nil)])
      end
      let(:boa_s) { beg_orig_arrangement.squares }
      let(:boa_orig) { boa_s[0] }
      let(:beg_block_orig) { boa_s[2] }

      let(:end_orig_arrangement) do
        Arrangement.new([Square.new(:d, 1, nil),
                         Square.new(:e, 1, :p),
                         Square.new(:f, 1, :p),
                         Square.new(:g, 1, nil),
                         Square.new(:h, 1, :p)])
      end
      let(:eoa_s) { end_orig_arrangement.squares }
      let(:eoa_orig) { eoa_s[4] }
      let(:end_block_orig) { eoa_s[2] }

      it "returns an array of squares not accessible to the origin square" do
        expect(misc_arrangement.relevant_blocked_squares(ma_orig))
          .to eq([ma_s[0], ma_s[1], ma_s[6]])
      end

      it "does not include the blocking squares" do
        expect(misc_arrangement.relevant_blocked_squares(ma_orig)
          .include?(ma_s[5])).to be(false)
      end

      context "with that square at the beginning of the Arrangement" do
        it "returns an array of squares not accessible to the origin square" do
          expect(beg_orig_arrangement.relevant_blocked_squares(boa_orig))
            .to eq([boa_s[4], boa_s[3]])
        end
      end

      context "with that square at the end of the Arrangement" do
        it "returns an array of squares not accessible to the origin square" do
          expect(end_orig_arrangement.relevant_blocked_squares(eoa_orig))
            .to eq([eoa_s[0], eoa_s[1]])
        end
      end

      context "with a blocking square at the beginning of the Arrangement" do
        it "returns an array of squares not accessible to the origin square" do
          expect(beg_orig_arrangement.relevant_blocked_squares(beg_block_orig))
            .to eq([boa_s[4]])
        end
      end

      context "with a blocking square at the end of the Arrangement" do
        it "returns an array of squares not accessible to the origin square" do
          expect(end_orig_arrangement.relevant_blocked_squares(end_block_orig))
            .to eq([eoa_s[0]])
        end
      end
    end
  end
end

describe Row do
  let(:row) do
    Row.new(1, %w(a1 b1), 10)
  end

  let(:player) { Player.new(:p1, :White) }
  let(:piece) { Pawn.new(player) }
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
        expect(true_row.to_s).to eq("1 █♙█ ♙  1")
      end
    end

    context "when the Row is empty" do
      context "with an odd rank" do
        it "returns a formatted string leading with a black square" do
          expect(empty_row1.to_s).to eq("1 ███    1")
        end
      end

      context "with an even rank" do
        it "returns a formatted string leading with a white square" do
          expect(empty_row2.to_s).to eq("2    ███ 2")
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
