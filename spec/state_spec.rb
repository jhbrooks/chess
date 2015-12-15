require "spec_helper"

describe State do
  let(:state) { State.new(1, [:p1, :p2], :board, 80) }

  describe "#new" do
    context "when given 4 arguments (turn, players, board, line_w)" do
      it "returns a State object" do
        expect(state).to be_an_instance_of(State)
      end
    end

    context "when given fewer than 4 arguments" do
      it "raises an ArgumentError" do
        expect { State.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 4 arguments" do
      it "raises an ArgumentError" do
        expect { State.new(1, 2, 3, 4, 5) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#turn" do
    it "returns the correct turn" do
      expect(state.turn).to eq(1)
    end
  end

  describe "#turn=" do
    it "correctly sets a new turn" do
      state.turn += 1
      expect(state.turn).to eq(2)
    end
  end

  describe "#players" do
    it "returns the correct collection of players" do
      expect(state.players).to eq([:p1, :p2])
    end
  end

  describe "#board" do
    it "returns the correct board" do
      expect(state.board).to eq(:board)
    end
  end

  describe "#board=" do
    it "correctly sets a new board" do
      state.board = :board2
      expect(state.board).to eq(:board2)
    end
  end

  describe "#line_w" do
    it "returns the correct line width" do
      expect(state.line_w).to eq(80)
    end
  end
end
