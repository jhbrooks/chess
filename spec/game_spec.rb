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

  describe "#set_up" do
    it "welcomes the user" do
      expect(game).to receive(:welcome_user)
      allow(game).to receive(:request_setup_command)
      game.set_up
    end

    it "requests a setup command" do
      allow(game).to receive(:welcome_user)
      expect(game).to receive(:request_setup_command)
      game.set_up
    end
  end

  describe "#welcome_user" do
    it "outputs a welcome message" do
      expect(STDOUT).to receive(:puts).with("\nWelcome to Ruby Chess!")
      game.welcome_user
    end
  end

  describe "#request_setup_command" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("start")
      allow(game).to receive(:start_game)
    end

    it "gets a command" do
      expect(STDIN).to receive(:gets)
      game.request_setup_command
    end

    it "checks to see if the command is valid" do
      expect(game).to receive(:setup_command_valid?)
        .and_return(false, true, true)
      game.request_setup_command
    end

    context "when the command is valid" do
      it "executes it" do
        expect(game).to receive(:execute_command)
        game.request_setup_command
      end

      it "does not try again" do
        expect(STDIN).to receive(:gets).once
        game.request_setup_command
      end
    end

    context "when the command is invalid" do
      before(:each) do
        allow(STDIN).to receive(:gets).and_return("invalid", "start")
      end

      it "does not execute it" do
        expect(game).to receive(:execute_command).once
        game.request_setup_command
      end

      it "tries again" do
        expect(STDIN).to receive(:gets).twice
        game.request_setup_command
      end
    end
  end

  describe "#setup_command_valid?" do
    context "when given 'START'" do
      it "returns true" do
        expect(game.setup_command_valid?("START")).to be(true)
      end
    end

    context "when given 'LOAD'" do
      it "returns true" do
        expect(game.setup_command_valid?("LOAD")).to be(true)
      end
    end

    context "when given 'QUIT'" do
      it "returns true" do
        expect(game.setup_command_valid?("QUIT")).to be(true)
      end
    end

    context "when given other commands" do
      it "returns false" do
        expect(game.setup_command_valid?("INVALID")).to be(false)
      end
    end
  end

  describe "#execute_command" do
    context "when given 'START'" do
      it "calls #start_game" do
        expect(game).to receive(:start_game)
        game.execute_command("START")
      end
    end

    context "when given 'LOAD'" do
      it "calls #load_game" do
        expect(game).to receive(:load_game)
        game.execute_command("LOAD")
      end
    end

    context "when given 'QUIT'" do
      it "calls #quit_game" do
        expect(game).to receive(:quit_game)
        game.execute_command("QUIT")
      end
    end

    context "when given 'MOVE'" do
      it "calls #determine_and_make_move" do
        expect(game).to receive(:determine_and_make_move)
        game.execute_command("MOVE")
      end
    end

    context "when given 'SAVE'" do
      it "calls #save_game" do
        expect(game).to receive(:save_game)
        game.execute_command("SAVE")
      end
    end
  end

  describe "#start_game" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
    end

    it "gets names for White and Black" do
      expect(STDIN).to receive(:gets).and_return("p1", "p2")
      allow(game).to receive(:play)
      game.start_game
    end

    it "sets a new state" do
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      expect(game).to receive(:state=)
      allow(game).to receive(:play)
      game.start_game
    end

    it "starts play" do
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      expect(game).to receive(:play)
      game.start_game
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
      allow(game).to receive(:request_play_command)
      game.play
    end

    it "requests a play command" do
      allow(game).to receive(:game_over?).and_return(false, false, true)
      allow(STDOUT).to receive(:puts).with(:state)
      expect(game).to receive(:request_play_command)
      game.play
    end

    context "when executing the command ends the Game" do
      before(:each) do
        allow(game).to receive(:game_over?).and_return(false, true, true)
      end

      it "outputs the state a second time" do
        allow(game).to receive(:request_play_command)
        expect(STDOUT).to receive(:puts).with(:state).twice
        game.play
      end

      it "does not advance the turn" do
        allow(STDOUT).to receive(:puts).with(:state)
        allow(game).to receive(:request_play_command)
        expect(game).to_not receive(:advance_turn)
        game.play
      end
    end

    context "when executing the command does not end the Game" do
      before(:each) do
        allow(game).to receive(:game_over?).and_return(false, false, true)
      end

      it "does not output the state a second time" do
        expect(STDOUT).to receive(:puts).with(:state)
        allow(game).to receive(:request_play_command)
        game.play
      end

      it "advances the turn" do
        allow(STDOUT).to receive(:puts).with(:state)
        allow(game).to receive(:request_play_command)
        expect(game).to receive(:advance_turn)
        game.play
      end
    end
  end

  describe "#request_play_command" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("move")
      allow(game).to receive(:determine_and_make_move)
    end

    it "gets a command" do
      expect(STDIN).to receive(:gets)
      game.request_play_command
    end

    it "checks to see if the command is valid" do
      expect(game).to receive(:play_command_valid?)
        .and_return(false, true, true)
      game.request_play_command
    end

    context "when the command is valid" do
      it "executes it" do
        expect(game).to receive(:execute_command)
        game.request_play_command
      end

      it "does not try again" do
        expect(STDIN).to receive(:gets).once
        game.request_play_command
      end
    end

    context "when the command is invalid" do
      before(:each) do
        allow(STDIN).to receive(:gets).and_return("invalid", "move")
      end

      it "does not execute it" do
        expect(game).to receive(:execute_command).once
        game.request_play_command
      end

      it "tries again" do
        expect(STDIN).to receive(:gets).twice
        game.request_play_command
      end
    end
  end

  describe "#play_command_valid?" do
    context "when given 'MOVE'" do
      it "returns true" do
        expect(game.play_command_valid?("MOVE")).to be(true)
      end
    end

    context "when given 'SAVE'" do
      it "returns true" do
        expect(game.play_command_valid?("SAVE")).to be(true)
      end
    end

    context "when given 'QUIT'" do
      it "returns true" do
        expect(game.play_command_valid?("QUIT")).to be(true)
      end
    end

    context "when given other commands" do
      it "returns false" do
        expect(game.play_command_valid?("INVALID")).to be(false)
      end
    end
  end
end
