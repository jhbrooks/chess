require "spec_helper"

describe Game do
  let(:game) { Game.new }

  describe "#new" do
    context "when given 0 arguments" do
      it "returns a Game object" do
        expect(game).to be_an_instance_of(Game)
      end
    end

    context "when given more than 0 arguments" do
      it "raises an ArgumentError" do
        expect { Game.new(1) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#state" do
    it "returns nil after initialization" do
      expect(game.state).to eq(nil)
    end
  end

  describe "#state=" do
    it "correctly sets a new state" do
      game.state = :state
      expect(game.state).to eq(:state)
    end
  end

  describe "#play" do
    before(:each) do
      game.state = :state
    end

    it "checks to see if the Game is over" do
      allow(game).to receive(:game_over?).and_return(true)
      expect(game).to receive(:game_over?)
      game.play
    end

    it "outputs the state" do
      allow(game).to receive(:game_over?).and_return(false, false, true)
      expect(STDOUT).to receive(:puts).with(:state)
      game.play
    end

    it "determines the next move" do
      allow(game).to receive(:game_over?).and_return(false, false, true)
      allow(STDOUT).to receive(:puts).with(:state)
      expect(game).to receive(:determine_move)
      game.play
    end

    it "makes the next move" do
      allow(game).to receive(:game_over?).and_return(false, false, true)
      allow(STDOUT).to receive(:puts).with(:state)
      expect(game).to receive(:make_move)
      game.play
    end

    context "when the move ends the Game" do
      before(:each) do
        allow(game).to receive(:game_over?).and_return(false, true, true)
      end

      it "outputs the state a second time" do
        expect(STDOUT).to receive(:puts).with(:state).twice
        game.play
      end

      it "does not advance the turn" do
        allow(STDOUT).to receive(:puts).with(:state)
        expect(game).to_not receive(:advance_turn)
        game.play
      end
    end

    context "when the move does not end the Game" do
      before(:each) do
        allow(game).to receive(:game_over?).and_return(false, false, true)
      end

      it "does not output the state a second time" do
        expect(STDOUT).to receive(:puts).with(:state)
        game.play
      end

      it "advances the turn" do
        allow(STDOUT).to receive(:puts).with(:state)
        expect(game).to receive(:advance_turn)
        game.play
      end
    end
  end
end
