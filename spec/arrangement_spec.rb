require "spec_helper"

describe Row do
  let(:row) { Row.new(1, %w(a1 b1), 10) }

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
    it "returns a formatted string representing the Row" do
      expect(row.to_s).to eq(" 1 a1b1")
    end
  end
end
