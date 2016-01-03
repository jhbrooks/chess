require "spec_helper"

describe Game do
  let(:game) { Game.new }

  describe ".new" do
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

  describe "#quit_status" do
    it "returns nil after initialization" do
      expect(game.quit_status).to eq(nil)
    end
  end

  describe "#quit_status=" do
    it "correctly sets a new quit status" do
      game.quit_status = true
      expect(game.quit_status).to be(true)
    end
  end

  describe "#setup_commands" do
    it "returns the correct collection of commands" do
      expect(game.setup_commands).to eq("START" => :start_game,
                                        "LOAD" => :load_game,
                                        "QUIT" => :quit_game)
    end
  end

  describe "#play_commands" do
    it "returns the correct collection of commands" do
      expect(game.play_commands).to eq("MOVE" => :determine_and_make_move,
                                       "SAVE" => :save_game,
                                       "QUIT" => :quit_game)
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

  describe "#quit_game" do
    context "when called during setup (state is nil)" do
      it "calls #quit_setup" do
        expect(game).to receive(:quit_setup)
        game.quit_game
      end
    end

    context "when called during play (state is not nil)" do
      it "calls #quit_play" do
        allow(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("p1", "p2")
        allow(game).to receive(:play)
        game.start_game

        expect(game).to receive(:quit_play)
        game.quit_game
      end
    end
  end

  describe "#quit_setup" do
    it "outputs a goodbye message" do
      expect(STDOUT).to receive(:puts).with("\nGoodbye!")
      game.quit_setup
    end
  end

  describe "#quit_play" do
    it "gets confirmation" do
      allow(STDOUT).to receive(:puts)
      expect(STDIN).to receive(:gets).and_return("no")
      game.quit_play
    end

    context "when confirmed" do
      before(:each) do
        allow(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("p1", "p2")
        allow(game).to receive(:play)
        game.start_game

        allow(STDIN).to receive(:gets).and_return("yes")
      end

      it "sets the quit status to true" do
        game.quit_play
        expect(game.quit_status).to be(true)
      end

      it "outputs that the current player has quit" do
        expect(STDOUT).to receive(:puts).with("\nWhite (p1) has quit!")
        game.quit_play
      end
    end
  end

  describe "#determine_and_make_move" do
    it "calls #determine_orig_pos" do
      expect(game).to receive(:determine_orig_pos)
      allow(game).to receive(:determine_targ_pos)
      allow(game).to receive(:make_move)
      game.determine_and_make_move
    end

    it "calls #determine_targ_pos" do
      allow(game).to receive(:determine_orig_pos)
      expect(game).to receive(:determine_targ_pos)
      allow(game).to receive(:make_move)
      game.determine_and_make_move
    end

    it "calls #make_move" do
      allow(game).to receive(:determine_orig_pos)
      allow(game).to receive(:determine_targ_pos).and_return(true)
      expect(game).to receive(:make_move)
      game.determine_and_make_move
    end
  end

  describe "#determine_orig_pos" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      allow(game).to receive(:play)
      game.start_game
    end

    it "gets an origin position" do
      allow(game.state).to receive(:valid_orig_pos?).and_return(false, true)
      expect(STDIN).to receive(:gets)
      game.determine_orig_pos
    end

    it "checks to see if the origin position is valid" do
      expect(game.state).to receive(:valid_orig_pos?).and_return(false, true)
      allow(STDIN).to receive(:gets).and_return("a1")
      game.determine_orig_pos
    end

    context "when the origin position is valid" do
      before(:each) do
        allow(game.state).to receive(:valid_orig_pos?).and_return(false, true)
        allow(STDIN).to receive(:gets).and_return("a1")
      end

      it "does not try again" do
        expect(STDIN).to receive(:gets).once
        game.determine_orig_pos
      end

      it "returns the origin position" do
        expect(game.determine_orig_pos).to eq([:a, 1])
      end
    end

    context "when the origin position is invalid" do
      it "tries again" do
        allow(game.state).to receive(:valid_orig_pos?)
          .and_return(false, false, true)
        allow(STDIN).to receive(:gets).and_return("a0", "a1")

        expect(STDIN).to receive(:gets).twice
        game.determine_orig_pos
      end
    end
  end

  describe "#determine_targ_pos" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      allow(game).to receive(:play)
      game.start_game
    end

    it "gets a target position" do
      allow(game.state).to receive(:valid_targ_pos?).and_return(false, true)
      expect(STDIN).to receive(:gets)
      game.determine_targ_pos([:a, 2])
    end

    it "checks to see if the target position is valid" do
      expect(game.state).to receive(:valid_targ_pos?).and_return(false, true)
      allow(STDIN).to receive(:gets).and_return("a3")
      game.determine_targ_pos([:a, 2])
    end

    context "when the target position is valid" do
      before(:each) do
        allow(game.state).to receive(:valid_targ_pos?).and_return(false, true)
        allow(STDIN).to receive(:gets).and_return("a3")
      end

      it "does not try again" do
        expect(STDIN).to receive(:gets).once
        game.determine_targ_pos([:a, 2])
      end

      it "returns the target position" do
        expect(game.determine_targ_pos([:a, 2])).to eq([:a, 3])
      end
    end

    context "when the target position is invalid" do
      it "tries again" do
        allow(game.state).to receive(:valid_targ_pos?)
          .and_return(false, false, true)
        allow(STDIN).to receive(:gets).and_return("a0", "a3")

        expect(STDIN).to receive(:gets).twice
        game.determine_targ_pos([:a, 2])
      end
    end

    context "when the target position includes the command 'DROP'" do
      before(:each) do
        allow(game.state).to receive(:valid_targ_pos?).and_return(false, true)
        allow(STDIN).to receive(:gets).and_return("drop")
      end

      it "does not try again" do
        expect(STDIN).to receive(:gets).once
        game.determine_targ_pos([:a, 2])
      end

      it "returns false" do
        expect(game.determine_targ_pos([:a, 2])).to be(false)
      end
    end
  end

  describe "#make_move" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      allow(game).to receive(:play)
      game.start_game
    end

    context "when the move ends the Game" do
      before(:each) do
        allow(game).to receive(:game_over?).and_return(true)
      end

      it "outputs the state" do
        expect(STDOUT).to receive(:puts).with(game.state)
        game.make_move([:a, 2], [:a, 3])
      end

      it "does not advance the turn" do
        expect(game).to_not receive(:advance_turn)
        game.make_move([:a, 2], [:a, 3])
      end

      context "with a checkmate" do
        before(:each) do
          game.state.make_move([:f, 2], [:f, 3])
          game.state.make_move([:g, 2], [:g, 4])

          game.advance_turn
          game.state.make_move([:e, 7], [:e, 5])
          game.state.make_move([:d, 8], [:h, 4])
        end

        it "outputs a checkmate message" do
          expect(STDOUT).to receive(:puts).with("Checkmate!")
          game.make_move([:a, 2], [:a, 3])
        end
      end

      context "with a draw" do
        before(:each) do
          game.state.make_move([:f, 2], [:f, 3])
          game.state.make_move([:g, 2], [:g, 4])

          game.advance_turn
          game.state.make_move([:e, 7], [:e, 5])
          game.state.make_move([:d, 8], [:h, 4])

          allow(game.state.next_player).to receive(:in_check)
            .and_return(false)
        end

        it "outputs a draw message" do
          expect(STDOUT).to receive(:puts).with("Draw.")
          game.make_move([:a, 2], [:a, 3])
        end
      end
    end

    context "when the move does not end the Game" do
      before(:each) do
        allow(game).to receive(:game_over?).and_return(false)
      end

      it "does not output the state" do
        expect(STDOUT).to_not receive(:puts).with(game.state)
        game.make_move([:a, 2], [:a, 3])
      end

      it "advances the turn" do
        expect(game).to receive(:advance_turn)
        game.make_move([:a, 2], [:a, 3])
      end

      it "adjusts the en passant position" do
        expect(game).to receive(:adjust_en_pass_pos)
        game.make_move([:a, 2], [:a, 3])
      end
    end
  end

  describe "#advance_turn" do
    it "increases the Game's state's turn by 1" do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      allow(game).to receive(:play)
      game.start_game

      game.advance_turn
      expect(game.state.turn).to eq(2)
    end
  end

  describe "#play" do
    before(:each) do
      allow(game).to receive(:reset_game)
      allow(game).to receive(:set_up)
    end

    it "checks to see if the Game is over" do
      allow(game).to receive(:game_over?).and_return(true)
      expect(game).to receive(:game_over?)
      game.play
    end

    it "outputs the state" do
      allow(game).to receive(:game_over?).and_return(false, true)
      expect(STDOUT).to receive(:puts).with(nil)
      allow(game).to receive(:request_play_command)
      game.play
    end

    it "requests a play command" do
      allow(game).to receive(:game_over?).and_return(false, true)
      allow(STDOUT).to receive(:puts).with(nil)
      expect(game).to receive(:request_play_command)
      game.play
    end

    context "when the Game is over" do
      it "resets the Game" do
        allow(game).to receive(:game_over?).and_return(true)
        expect(game).to receive(:reset_game)
        game.play
      end

      it "returns to setup" do
        allow(game).to receive(:game_over?).and_return(true)
        expect(game).to receive(:set_up)
        game.play
      end
    end
  end

  describe "#game_over?" do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(STDIN).to receive(:gets).and_return("p1", "p2")
      allow(game).to receive(:play)
      game.start_game
    end

    context "when a checkmate occurs" do
      before(:each) do
        game.state.make_move([:f, 2], [:f, 3])
        game.state.make_move([:g, 2], [:g, 4])

        game.advance_turn
        game.state.make_move([:e, 7], [:e, 5])
        game.state.make_move([:d, 8], [:h, 4])
      end

      it "returns true" do
        expect(game.game_over?).to be(true)
      end
    end

    context "when a draw occurs" do
      before(:each) do
        game.state.make_move([:f, 2], [:f, 3])
        game.state.make_move([:g, 2], [:g, 4])

        game.advance_turn
        game.state.make_move([:e, 7], [:e, 5])
        game.state.make_move([:d, 8], [:h, 4])

        game.state.players[0].in_check = false
      end

      it "returns true" do
        expect(game.game_over?).to be(true)
      end
    end

    context "after #quit_play is called and confirmed" do
      it "returns true" do
        expect(STDIN).to receive(:gets).and_return("yes")
        game.quit_play
        expect(game.game_over?).to be(true)
      end
    end

    context "otherwise" do
      it "returns false" do
        expect(game.game_over?).to be(false)
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

  describe "#reset_game" do
    it "sets the state to nil" do
      game.state = :state
      game.reset_game
      expect(game.state).to be(nil)
    end

    it "sets the quit status to nil" do
      game.quit_status = true
      game.reset_game
      expect(game.quit_status).to be(nil)
    end
  end
end
