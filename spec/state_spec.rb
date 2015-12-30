require "spec_helper"

describe State do
  let(:state) { State.new([:p1, :p2], 24) }
  let(:players) { [Player.new(:p1, :White), Player.new(:p2, :Black)] }
  let(:true_state) { State.new(players, 24) }

  describe "#new" do
    context "when given 2 arguments (players, line_w)" do
      it "returns a State object" do
        expect(state).to be_an_instance_of(State)
      end
    end

    context "when given fewer than 2 arguments" do
      it "raises an ArgumentError" do
        expect { State.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 2 arguments" do
      it "raises an ArgumentError" do
        expect { State.new(1, 2, 3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#turn" do
    it "returns 1 after initialization" do
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
    it "returns a Board object" do
      expect(state.board).to be_an_instance_of(Board)
    end
  end

  describe "#line_w" do
    it "returns the correct line width" do
      expect(state.line_w).to eq(24)
    end
  end

  describe "#current_player" do
    context "when turn is odd" do
      it "returns the first player in players" do
        expect(state.current_player).to eq(:p1)
      end
    end

    context "when turn is even" do
      it "returns the second player in players" do
        state.turn += 1
        expect(state.current_player).to eq(:p2)
      end
    end
  end

  describe "#valid_origin?" do
    context "when the given position is off-board" do
      it "returns a falsey value" do
        expect(state.valid_origin?([:a, 0])).to be_falsey
      end
    end

    context "when the given position matches an empty square" do
      it "returns a falsey value" do
        expect(state.valid_origin?([:a, 3])).to be_falsey
      end
    end

    context "when the given position matches a square with an enemy piece" do
      it "returns a falsey value" do
        expect(state.valid_origin?([:a, 8])).to be_falsey
      end
    end

    context "when the given position is a valid move origin" do
      it "returns true" do
        expect(state.valid_origin?([:a, 1])).to be(true)
      end
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the State" do
      expect(true_state.to_s).to eq("\n  White (p1) to play.   \n\n"\
                                    "     a b c d e f g h\n"\
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
