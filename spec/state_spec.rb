require "spec_helper"

describe State do
  let(:state) { State.new([:p1, :p2], 24) }
  let(:players) { [Player.new(:p1, :White), Player.new(:p2, :Black)] }
  let(:true_state) { State.new(players, 24) }

  describe ".new" do
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

  describe "#last_orig_piece" do
    it "returns nil after initialization" do
      expect(state.last_orig_piece).to be(nil)
    end
  end

  describe "#last_orig_piece=" do
    it "correctly sets a new last origin piece" do
      state.last_orig_piece = :piece
      expect(state.last_orig_piece).to eq(:piece)
    end
  end

  describe "#last_targ_piece" do
    it "returns nil after initialization" do
      expect(state.last_targ_piece).to be(nil)
    end
  end

  describe "#last_targ_piece=" do
    it "correctly sets a new last target piece" do
      state.last_targ_piece = :piece
      expect(state.last_targ_piece).to eq(:piece)
    end
  end

  describe "#last_unmoved_status" do
    it "returns nil after initialization" do
      expect(state.last_unmoved_status).to be(nil)
    end
  end

  describe "#last_unmoved_status=" do
    it "correctly sets a new last check status" do
      state.last_unmoved_status = true
      expect(state.last_unmoved_status).to be(true)
    end
  end

  describe "#en_pass_pos" do
    it "returns nil after initialization" do
      expect(state.en_pass_pos).to be(nil)
    end
  end

  describe "#en_pass_pos=" do
    it "correctly sets a new en passant position" do
      state.en_pass_pos = [:a, 4]
      expect(state.en_pass_pos).to eq([:a, 4])
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

  describe "#next_player" do
    context "when turn is odd" do
      it "returns the second player in players" do
        expect(state.next_player).to eq(:p2)
      end
    end

    context "when turn is even" do
      it "returns the first player in players" do
        state.turn += 1
        expect(state.next_player).to eq(:p1)
      end
    end
  end

  describe "#valid_orig_pos?" do
    context "when the given position is off-board" do
      it "returns a falsey value" do
        expect(true_state.valid_orig_pos?([:a, 0])).to be_falsey
      end
    end

    context "when the given position matches an empty square" do
      it "returns false" do
        expect(true_state.valid_orig_pos?([:a, 3])).to be(false)
      end
    end

    context "when the given position matches an enemy square" do
      it "returns false" do
        expect(true_state.valid_orig_pos?([:a, 8])).to be(false)
      end
    end

    context "when the given position is a valid move origin" do
      it "returns true" do
        expect(true_state.valid_orig_pos?([:a, 1])).to be(true)
      end
    end
  end

  describe "#valid_targ_pos?" do
    context "when the given target position is off-board" do
      it "returns false" do
        expect(true_state.valid_targ_pos?([:d, 1], [:d, 0])).to be(false)
      end
    end

    context "when the given target position matches the origin position" do
      it "returns false" do
        expect(true_state.valid_targ_pos?([:d, 1], [:d, 1])).to be(false)
      end
    end

    context "when the piece at the origin can't reach the target position" do
      it "returns false" do
        expect(true_state.valid_targ_pos?([:d, 1], [:d, 3])).to be(false)
      end
    end

    context "when the given target position matches a friendly square" do
      it "returns false" do
        expect(true_state.valid_targ_pos?([:d, 1], [:d, 2])).to be(false)
      end
    end

    context "when the move described would leave the mover in check" do
      before(:each) do
        true_state.make_move([:e, 2], [:e, 4])

        true_state.make_move([:d, 8], [:g, 4])
      end

      it "returns false" do
        allow(STDOUT).to receive(:puts)
        expect(true_state.valid_targ_pos?([:e, 1], [:e, 2])).to be(false)
      end

      it "outputs a warning message" do
        expect(STDOUT).to receive(:puts)
        true_state.valid_targ_pos?([:e, 1], [:e, 2])
      end
    end

    context "when the move described is a valid move" do
      it "returns true" do
        expect(true_state.valid_targ_pos?([:d, 2], [:d, 3])).to be(true)
      end
    end

    context "when the move described is a valid capture" do
      it "returns true" do
        true_state.make_move([:c, 7], [:c, 3])

        expect(true_state.valid_targ_pos?([:d, 2], [:c, 3])).to be(true)
      end
    end
  end

  describe "#legal_moves" do
    before(:each) do
      true_state.make_move([:e, 2], [:e, 4])
    end

    it "does not include moves that place the current player in check" do
      true_state.make_move([:d, 8], [:g, 4])
      expect(true_state.legal_moves([:e, 1]).include?([:e, 2])).to be(false)
    end

    it "does not include moves that leave the current player in check" do
      true_state.make_move([:d, 8], [:f, 2])
      expect(true_state.legal_moves([:a, 2]).include?([:a, 3])).to be(false)
    end

    it "includes other legal moves" do
      true_state.make_move([:d, 2], [:d, 3])

      true_state.make_move([:d, 8], [:g, 4])
      expect(true_state.legal_moves([:e, 1]).include?([:d, 2])).to be(true)
    end

    context "when the piece at the origin position is a White King" do
      context "with a castle long available" do
        before(:each) do
          true_state.make_move([:b, 1], [:b, 3])
          true_state.make_move([:c, 1], [:c, 3])
          true_state.make_move([:d, 1], [:d, 3])
        end

        context "with no disqualifying characteristics" do
          it "includes that special move" do
            expect(true_state.legal_moves([:e, 1]).include?("CL")).to be(true)
          end
        end

        context "with a threatened square in the King's path" do
          it "does not include that special move" do
            true_state.make_move([:a, 8], [:c, 2])
            expect(true_state.legal_moves([:e, 1]).include?("CL")).to be(false)
          end
        end

        context "with a moved King" do
          it "does not include that special move" do
            true_state.make_move([:e, 1], [:d, 1])
            true_state.make_move([:d, 1], [:e, 1])
            expect(true_state.legal_moves([:e, 1]).include?("CL")).to be(false)
          end
        end

        context "with a moved Rook" do
          it "does not include that special move" do
            true_state.make_move([:a, 1], [:b, 1])
            true_state.make_move([:b, 1], [:a, 1])
            expect(true_state.legal_moves([:e, 1]).include?("CL")).to be(false)
          end
        end
      end

      context "with a castle short available" do
        before(:each) do
          true_state.make_move([:f, 1], [:f, 3])
          true_state.make_move([:g, 1], [:g, 3])
        end

        context "with no disqualifying characteristics" do
          it "includes that special move" do
            expect(true_state.legal_moves([:e, 1]).include?("CS")).to be(true)
          end
        end

        context "with a threatened square in the King's path" do
          it "does not include that special move" do
            true_state.make_move([:h, 8], [:f, 2])
            expect(true_state.legal_moves([:e, 1]).include?("CS")).to be(false)
          end
        end

        context "with a moved King" do
          it "does not include that special move" do
            true_state.make_move([:e, 1], [:f, 1])
            true_state.make_move([:f, 1], [:e, 1])
            expect(true_state.legal_moves([:e, 1]).include?("CS")).to be(false)
          end
        end

        context "with a moved Rook" do
          it "does not include that special move" do
            true_state.make_move([:h, 1], [:g, 1])
            true_state.make_move([:g, 1], [:h, 1])
            expect(true_state.legal_moves([:e, 1]).include?("CS")).to be(false)
          end
        end
      end
    end

    context "when the piece at the origin position is a Black King" do
      context "with a castle long available" do
        before(:each) do
          true_state.make_move([:b, 8], [:b, 6])
          true_state.make_move([:c, 8], [:c, 6])
          true_state.make_move([:d, 8], [:d, 6])
        end

        context "with no disqualifying characteristics" do
          it "includes that special move" do
            expect(true_state.legal_moves([:e, 8]).include?("CL")).to be(true)
          end
        end

        context "with a threatened square in the King's path" do
          it "does not include that special move" do
            true_state.make_move([:a, 1], [:c, 7])
            expect(true_state.legal_moves([:e, 8]).include?("CL")).to be(false)
          end
        end

        context "with a moved King" do
          it "does not include that special move" do
            true_state.make_move([:e, 8], [:d, 8])
            true_state.make_move([:d, 8], [:e, 8])
            expect(true_state.legal_moves([:e, 8]).include?("CL")).to be(false)
          end
        end

        context "with a moved Rook" do
          it "does not include that special move" do
            true_state.make_move([:a, 8], [:b, 8])
            true_state.make_move([:b, 8], [:a, 8])
            expect(true_state.legal_moves([:e, 8]).include?("CL")).to be(false)
          end
        end
      end

      context "with a castle short available" do
        before(:each) do
          true_state.make_move([:f, 8], [:f, 6])
          true_state.make_move([:g, 8], [:g, 6])
        end

        context "with no disqualifying characteristics" do
          it "includes that special move" do
            expect(true_state.legal_moves([:e, 8]).include?("CS")).to be(true)
          end
        end

        context "with a threatened square in the King's path" do
          it "does not include that special move" do
            true_state.make_move([:h, 1], [:f, 7])
            expect(true_state.legal_moves([:e, 8]).include?("CS")).to be(false)
          end
        end

        context "with a moved King" do
          it "does not include that special move" do
            true_state.make_move([:e, 8], [:f, 8])
            true_state.make_move([:f, 8], [:e, 8])
            expect(true_state.legal_moves([:e, 8]).include?("CS")).to be(false)
          end
        end

        context "with a moved Rook" do
          it "does not include that special move" do
            true_state.make_move([:h, 8], [:g, 8])
            true_state.make_move([:g, 8], [:h, 8])
            expect(true_state.legal_moves([:e, 8]).include?("CS")).to be(false)
          end
        end
      end
    end

    context "when the piece at the origin position is a White Pawn" do
      context "in position for an en passant" do
        before(:each) do
          true_state.make_move([:b, 2], [:b, 5])

          true_state.make_move([:c, 7], [:c, 5])
        end

        context "with @en_pass_pos set to the appropriate position" do
          it "includes that special move" do
            true_state.en_pass_pos = [:c, 5]
            expect(true_state.legal_moves([:b, 5]).include?("EP")).to be(true)
          end
        end

        context "with @en_pass_pos set to nil" do
          it "does not include that special move" do
            expect(true_state.legal_moves([:b, 5]).include?("EP")).to be(false)
          end
        end
      end

      context "out of position for an en passant" do
        before(:each) do
          true_state.make_move([:b, 2], [:b, 4])

          true_state.make_move([:c, 7], [:c, 5])
        end

        context "with @en_pass_pos set to a position" do
          it "does not include that special move" do
            true_state.en_pass_pos = [:c, 5]
            expect(true_state.legal_moves([:b, 4]).include?("EP")).to be(false)
          end
        end

        context "with @en_pass_pos set to nil" do
          it "does not include that special move" do
            expect(true_state.legal_moves([:b, 4]).include?("EP")).to be(false)
          end
        end
      end
    end

    context "when the piece at the origin position is a Black Pawn" do
      context "in position for an en passant" do
        before(:each) do
          true_state.make_move([:b, 7], [:b, 4])

          true_state.make_move([:c, 2], [:c, 4])
        end

        context "with @en_pass_pos set to the appropriate position" do
          it "includes that special move" do
            true_state.en_pass_pos = [:c, 4]
            expect(true_state.legal_moves([:b, 4]).include?("EP")).to be(true)
          end
        end

        context "with @en_pass_pos set to nil" do
          it "does not include that special move" do
            expect(true_state.legal_moves([:b, 4]).include?("EP")).to be(false)
          end
        end
      end

      context "out of position for an en passant" do
        before(:each) do
          true_state.make_move([:b, 7], [:b, 5])

          true_state.make_move([:c, 2], [:c, 4])
        end

        context "with @en_pass_pos set to a position" do
          it "does not include that special move" do
            true_state.en_pass_pos = [:c, 4]
            expect(true_state.legal_moves([:b, 5]).include?("EP")).to be(false)
          end
        end

        context "with @en_pass_pos set to nil" do
          it "does not include that special move" do
            expect(true_state.legal_moves([:b, 5]).include?("EP")).to be(false)
          end
        end
      end
    end
  end

  describe "#make_move" do
    it "sets the moved piece's @unmoved attribute to false" do
      true_state.make_move([:a, 2], [:a, 4])
      expect(true_state.board.square([:a, 4]).piece.unmoved).to be(false)
    end

    context "when the move is a special move" do
      it "calls the #make_special_move method" do
        expect(true_state).to receive(:make_special_move)
        true_state.make_move([:e, 1], "CL")
      end
    end

    context "when the move is a normal move" do
      it "calls the Board#make_move method" do
        expect(true_state.board).to receive(:make_move)
        true_state.make_move([:a, 2], [:a, 4])
      end
    end

    context "when the move puts the current player in check" do
      it "sets that player's @in_check attribute to true" do
        true_state.make_move([:d, 8], [:d, 2])
        expect(true_state.current_player.in_check).to be(true)
      end
    end

    context "when the move takes the current player out of check" do
      it "sets that player's @in_check attribute to false" do
        true_state.make_move([:d, 8], [:d, 2])

        true_state.make_move([:e, 1], [:d, 2])
        expect(true_state.current_player.in_check).to be(false)
      end
    end

    context "when the move puts the next player in check" do
      it "sets that player's @in_check attribute to true" do
        true_state.make_move([:d, 1], [:d, 7])
        expect(true_state.next_player.in_check).to be(true)
      end
    end

    context "when the move takes the next player out of check" do
      it "sets that player's @in_check attribute to false" do
        true_state.make_move([:d, 1], [:d, 7])

        true_state.make_move([:e, 8], [:d, 7])
        expect(true_state.next_player.in_check).to be(false)
      end
    end
  end

  describe "#make_special_move" do
    context "with a White piece at the origin position" do
      context "when given the en passant special move" do
        before(:each) do
          true_state.make_move([:b, 2], [:b, 5])

          true_state.make_move([:c, 7], [:c, 5])
          true_state.en_pass_pos = [:c, 5]
        end

        it "correctly moves the White Pawn" do
          expect(true_state.board).to receive(:make_move)
            .with([:b, 5], [:c, 6])
          true_state.make_special_move([:b, 5], "EP")
        end

        it "correctly removes the Black Pawn" do
          true_state.make_special_move([:b, 5], "EP")
          expect(true_state.board.square([:c, 5]).piece).to be(nil)
        end
      end

      context "when given the castle long special move" do
        before(:each) do
          true_state.make_move([:b, 1], [:b, 3])
          true_state.make_move([:c, 1], [:c, 3])
          true_state.make_move([:d, 1], [:d, 3])
        end

        it "correctly moves the White King" do
          expect(true_state.board).to receive(:make_move)
            .with([:e, 1], [:c, 1])
          allow(true_state.board).to receive(:make_move)
            .with([:a, 1], [:d, 1])
          true_state.make_special_move([:e, 1], "CL")
        end

        it "correctly moves the correct White Rook" do
          allow(true_state.board).to receive(:make_move)
            .with([:e, 1], [:c, 1])
          expect(true_state.board).to receive(:make_move)
            .with([:a, 1], [:d, 1])
          true_state.make_special_move([:e, 1], "CL")
        end

        it "adjusts the unmoved status of the correct White Rook" do
          true_state.make_special_move([:e, 1], "CL")
          expect(true_state.board.square([:d, 1]).piece.unmoved).to be(false)
        end
      end

      context "when given the castle short special move" do
        before(:each) do
          true_state.make_move([:f, 1], [:f, 3])
          true_state.make_move([:g, 1], [:g, 3])
        end

        it "correctly moves the White King" do
          expect(true_state.board).to receive(:make_move)
            .with([:e, 1], [:g, 1])
          allow(true_state.board).to receive(:make_move)
            .with([:h, 1], [:f, 1])
          true_state.make_special_move([:e, 1], "CS")
        end

        it "correctly moves the correct White Rook" do
          allow(true_state.board).to receive(:make_move)
            .with([:e, 1], [:g, 1])
          expect(true_state.board).to receive(:make_move)
            .with([:h, 1], [:f, 1])
          true_state.make_special_move([:e, 1], "CS")
        end

        it "adjusts the unmoved status of the correct White Rook" do
          true_state.make_special_move([:e, 1], "CS")
          expect(true_state.board.square([:f, 1]).piece.unmoved).to be(false)
        end
      end
    end

    context "with a Black piece at the origin position" do
      context "when given the en passant special move" do
        before(:each) do
          true_state.make_move([:b, 7], [:b, 4])

          true_state.make_move([:c, 2], [:c, 4])
          true_state.en_pass_pos = [:c, 4]
        end

        it "correctly moves the Black Pawn" do
          expect(true_state.board).to receive(:make_move)
            .with([:b, 4], [:c, 3])
          true_state.make_special_move([:b, 4], "EP")
        end

        it "correctly removes the White Pawn" do
          true_state.make_special_move([:b, 4], "EP")
          expect(true_state.board.square([:c, 4]).piece).to be(nil)
        end
      end

      context "when given the castle long special move" do
        before(:each) do
          true_state.make_move([:b, 8], [:b, 6])
          true_state.make_move([:c, 8], [:c, 6])
          true_state.make_move([:d, 8], [:d, 6])
        end

        it "correctly moves the Black King" do
          expect(true_state.board).to receive(:make_move)
            .with([:e, 8], [:c, 8])
          allow(true_state.board).to receive(:make_move)
            .with([:a, 8], [:d, 8])
          true_state.make_special_move([:e, 8], "CL")
        end

        it "correctly moves the correct Black Rook" do
          allow(true_state.board).to receive(:make_move)
            .with([:e, 8], [:c, 8])
          expect(true_state.board).to receive(:make_move)
            .with([:a, 8], [:d, 8])
          true_state.make_special_move([:e, 8], "CL")
        end

        it "adjusts the unmoved status of the correct Black Rook" do
          true_state.make_special_move([:e, 8], "CL")
          expect(true_state.board.square([:d, 8]).piece.unmoved).to be(false)
        end
      end

      context "when given the castle short special move" do
        before(:each) do
          true_state.make_move([:f, 8], [:f, 6])
          true_state.make_move([:g, 8], [:g, 6])
        end

        it "correctly moves the Black King" do
          expect(true_state.board).to receive(:make_move)
            .with([:e, 8], [:g, 8])
          allow(true_state.board).to receive(:make_move)
            .with([:h, 8], [:f, 8])
          true_state.make_special_move([:e, 8], "CS")
        end

        it "correctly moves the correct Black Rook" do
          allow(true_state.board).to receive(:make_move)
            .with([:e, 8], [:g, 8])
          expect(true_state.board).to receive(:make_move)
            .with([:h, 8], [:f, 8])
          true_state.make_special_move([:e, 8], "CS")
        end

        it "adjusts the unmoved status of the correct Black Rook" do
          true_state.make_special_move([:e, 8], "CS")
          expect(true_state.board.square([:f, 8]).piece.unmoved).to be(false)
        end
      end
    end
  end

  describe "#store_move" do
    before(:each) do
      true_state.store_move([:a, 2], [:a, 3])
      true_state.make_move([:a, 2], [:a, 3])
    end

    it "stores the correct last origin piece" do
      expect(true_state.last_orig_piece).to be_an_instance_of(Pawn)
    end

    context "when the piece in the origin position has not moved" do
      it "stores the correct last unmoved status" do
        expect(true_state.last_unmoved_status).to be(true)
      end
    end

    context "when the piece in the origin position has moved" do
      it "stores the correct last unmoved status" do
        true_state.store_move([:a, 3], [:a, 4])
        true_state.make_move([:a, 3], [:a, 4])
        expect(true_state.last_unmoved_status).to be(false)
      end
    end

    context "when the move is a special move" do
      it "calls the #store_special_move method" do
        expect(true_state).to receive(:store_special_move)
        true_state.store_move([:e, 1], "CL")
      end
    end

    context "when the move is a normal move" do
      context "with an empty target square" do
        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be(nil)
        end
      end

      context "with an occupied target square" do
        it "stores the correct last target piece" do
          true_state.make_move([:a, 3], [:a, 6])
          true_state.store_move([:a, 6], [:b, 7])
          true_state.make_move([:a, 6], [:b, 7])
          expect(true_state.last_targ_piece).to be_an_instance_of(Pawn)
        end
      end
    end
  end

  describe "#store_special_move" do
    context "with a White piece at the origin position" do
      context "when given the en passant special move" do
        before(:each) do
          true_state.make_move([:b, 2], [:b, 5])

          true_state.make_move([:c, 7], [:c, 5])
          true_state.en_pass_pos = [:c, 5]

          true_state.store_special_move([:b, 5], "EP")
          true_state.make_special_move([:b, 5], "EP")
        end

        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be_an_instance_of(Pawn)
          expect(true_state.last_targ_piece.player.color).to eq(:Black)
        end
      end

      context "when given the castle long special move" do
        before(:each) do
          true_state.make_move([:b, 1], [:b, 3])
          true_state.make_move([:c, 1], [:c, 3])
          true_state.make_move([:d, 1], [:d, 3])

          true_state.store_special_move([:e, 1], "CL")
          true_state.make_special_move([:e, 1], "CL")
        end

        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be_an_instance_of(Rook)
          expect(true_state.last_targ_piece.player.color).to eq(:White)
        end
      end

      context "when given the castle short special move" do
        before(:each) do
          true_state.make_move([:f, 1], [:f, 3])
          true_state.make_move([:g, 1], [:g, 3])

          true_state.store_special_move([:e, 1], "CS")
          true_state.make_special_move([:e, 1], "CS")
        end

        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be_an_instance_of(Rook)
          expect(true_state.last_targ_piece.player.color).to eq(:White)
        end
      end
    end

    context "with a Black piece at the origin position" do
      context "when given the en passant special move" do
        before(:each) do
          true_state.make_move([:b, 7], [:b, 4])

          true_state.make_move([:c, 2], [:c, 4])
          true_state.en_pass_pos = [:c, 4]

          true_state.store_special_move([:b, 4], "EP")
          true_state.make_special_move([:b, 4], "EP")
        end

        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be_an_instance_of(Pawn)
          expect(true_state.last_targ_piece.player.color).to eq(:White)
        end
      end

      context "when given the castle long special move" do
        before(:each) do
          true_state.make_move([:b, 8], [:b, 6])
          true_state.make_move([:c, 8], [:c, 6])
          true_state.make_move([:d, 8], [:d, 6])

          true_state.store_special_move([:e, 8], "CL")
          true_state.make_special_move([:e, 8], "CL")
        end

        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be_an_instance_of(Rook)
          expect(true_state.last_targ_piece.player.color).to eq(:Black)
        end
      end

      context "when given the castle short special move" do
        before(:each) do
          true_state.make_move([:f, 8], [:f, 6])
          true_state.make_move([:g, 8], [:g, 6])

          true_state.store_special_move([:e, 8], "CS")
          true_state.make_special_move([:e, 8], "CS")
        end

        it "stores the correct last target piece" do
          expect(true_state.last_targ_piece).to be_an_instance_of(Rook)
          expect(true_state.last_targ_piece.player.color).to eq(:Black)
        end
      end
    end
  end

  describe "#undo_move" do
    it "returns the moved piece to its origin square" do
      true_state.store_move([:a, 2], [:a, 4])
      true_state.make_move([:a, 2], [:a, 4])
      true_state.undo_move([:a, 2], [:a, 4])
      expect(true_state.board.square([:a, 2]).piece).to be_an_instance_of(Pawn)
    end

    it "resets the moved piece's @unmoved attribute" do
      true_state.store_move([:a, 2], [:a, 4])
      true_state.make_move([:a, 2], [:a, 4])
      true_state.undo_move([:a, 2], [:a, 4])
      expect(true_state.board.square([:a, 2]).piece.unmoved).to be(true)
    end

    context "when the move is a special move" do
      it "calls the #undo_special_move method" do
        expect(true_state).to receive(:undo_special_move)
        true_state.store_move([:e, 1], "CL")
        true_state.make_move([:e, 1], "CL")
        true_state.undo_move([:e, 1], "CL")
      end
    end

    context "when the move is a normal move" do
      context "with an empty target square" do
        it "restores the target square's nil piece" do
          true_state.store_move([:a, 2], [:a, 4])
          true_state.make_move([:a, 2], [:a, 4])
          true_state.undo_move([:a, 2], [:a, 4])
          expect(true_state.board.square([:a, 4]).piece).to be(nil)
        end
      end

      context "with an occupied target square" do
        it "restores the target square's piece" do
          true_state.make_move([:a, 2], [:a, 6])
          true_state.store_move([:a, 6], [:b, 7])
          true_state.make_move([:a, 6], [:b, 7])
          true_state.undo_move([:a, 6], [:b, 7])
          expect(true_state.board.square([:b, 7]).piece)
            .to be_an_instance_of(Pawn)
          expect(true_state.board.square([:b, 7]).piece.player.color)
            .to be(:Black)
        end
      end
    end

    context "when the undo move puts the current player in check" do
      it "sets that player's @in_check attribute to true" do
        true_state.make_move([:d, 8], [:d, 2])
        true_state.store_move([:d, 2], [:a, 3])
        true_state.make_move([:d, 2], [:a, 3])
        true_state.undo_move([:d, 2], [:a, 3])
        expect(true_state.current_player.in_check).to be(true)
      end
    end

    context "when the undo move takes the current player out of check" do
      it "sets that player's @in_check attribute to false" do
        true_state.store_move([:d, 8], [:d, 2])
        true_state.make_move([:d, 8], [:d, 2])
        true_state.undo_move([:d, 8], [:d, 2])
        expect(true_state.current_player.in_check).to be(false)
      end
    end

    context "when the undo move puts the next player in check" do
      it "sets that player's @in_check attribute to true" do
        true_state.make_move([:d, 1], [:d, 7])
        true_state.store_move([:d, 7], [:a, 6])
        true_state.make_move([:d, 7], [:a, 6])
        true_state.undo_move([:d, 7], [:a, 6])
        expect(true_state.next_player.in_check).to be(true)
      end
    end

    context "when the undo move takes the next player out of check" do
      it "sets that player's @in_check attribute to false" do
        true_state.store_move([:d, 1], [:d, 7])
        true_state.make_move([:d, 1], [:d, 7])
        true_state.undo_move([:d, 1], [:d, 7])
        expect(true_state.next_player.in_check).to be(false)
      end
    end
  end

  describe "#undo_special_move" do
    context "with a White piece at the origin position" do
      context "when given the en passant special move" do
        before(:each) do
          true_state.make_move([:b, 2], [:b, 5])

          true_state.make_move([:c, 7], [:c, 5])
          true_state.en_pass_pos = [:c, 5]

          true_state.store_move([:b, 5], "EP")
          true_state.make_special_move([:b, 5], "EP")
          true_state.undo_move([:b, 5], "EP")
        end

        it "correctly unmoves the White Pawn" do
          expect(true_state.board.square([:c, 6]).piece).to be(nil)
        end

        it "correctly replaces the Black Pawn" do
          expect(true_state.board.square([:c, 5]).piece)
            .to be_an_instance_of(Pawn)
          expect(true_state.board.square([:c, 5]).piece.player.color)
            .to be(:Black)
        end
      end

      context "when given the castle long special move" do
        before(:each) do
          true_state.make_move([:b, 1], [:b, 3])
          true_state.make_move([:c, 1], [:c, 3])
          true_state.make_move([:d, 1], [:d, 3])

          true_state.store_move([:e, 1], "CL")
          true_state.make_special_move([:e, 1], "CL")
          true_state.undo_move([:e, 1], "CL")
        end

        it "correctly unmoves the White King" do
          expect(true_state.board.square([:b, 1]).piece).to be(nil)
        end

        it "correctly unmoves the correct White Rook" do
          expect(true_state.board.square([:c, 1]).piece).to be(nil)
          expect(true_state.board.square([:a, 1]).piece)
            .to be_an_instance_of(Rook)
        end

        it "undos adjusting the unmoved status of the correct White Rook" do
          expect(true_state.board.square([:a, 1]).piece.unmoved).to be(true)
        end
      end

      context "when given the castle short special move" do
        before(:each) do
          true_state.make_move([:f, 1], [:f, 3])
          true_state.make_move([:g, 1], [:g, 3])

          true_state.store_move([:e, 1], "CS")
          true_state.make_special_move([:e, 1], "CS")
          true_state.undo_move([:e, 1], "CS")
        end

        it "correctly unmoves the White King" do
          expect(true_state.board.square([:g, 1]).piece).to be(nil)
        end

        it "correctly unmoves the correct White Rook" do
          expect(true_state.board.square([:f, 1]).piece).to be(nil)
          expect(true_state.board.square([:h, 1]).piece)
            .to be_an_instance_of(Rook)
        end

        it "undos adjusting the unmoved status of the correct White Rook" do
          expect(true_state.board.square([:h, 1]).piece.unmoved).to be(true)
        end
      end
    end

    context "with a Black piece at the origin position" do
      context "when given the en passant special move" do
        before(:each) do
          true_state.make_move([:b, 7], [:b, 4])

          true_state.make_move([:c, 2], [:c, 4])
          true_state.en_pass_pos = [:c, 4]

          true_state.store_move([:b, 4], "EP")
          true_state.make_special_move([:b, 4], "EP")
          true_state.undo_move([:b, 4], "EP")
        end

        it "correctly unmoves the Black Pawn" do
          expect(true_state.board.square([:c, 3]).piece).to be(nil)
        end

        it "correctly replaces the White Pawn" do
          expect(true_state.board.square([:c, 4]).piece)
            .to be_an_instance_of(Pawn)
          expect(true_state.board.square([:c, 4]).piece.player.color)
            .to be(:White)
        end
      end

      context "when given the castle long special move" do
        before(:each) do
          true_state.make_move([:b, 8], [:b, 6])
          true_state.make_move([:c, 8], [:c, 6])
          true_state.make_move([:d, 8], [:d, 6])

          true_state.store_move([:e, 8], "CL")
          true_state.make_special_move([:e, 8], "CL")
          true_state.undo_move([:e, 8], "CL")
        end

        it "correctly unmoves the Black King" do
          expect(true_state.board.square([:b, 8]).piece).to be(nil)
        end

        it "correctly unmoves the correct Black Rook" do
          expect(true_state.board.square([:c, 8]).piece).to be(nil)
          expect(true_state.board.square([:a, 8]).piece)
            .to be_an_instance_of(Rook)
        end

        it "undos adjusting the unmoved status of the correct Black Rook" do
          expect(true_state.board.square([:a, 8]).piece.unmoved).to be(true)
        end
      end

      context "when given the castle short special move" do
        before(:each) do
          true_state.make_move([:f, 8], [:f, 6])
          true_state.make_move([:g, 8], [:g, 6])

          true_state.store_move([:e, 8], "CS")
          true_state.make_special_move([:e, 8], "CS")
          true_state.undo_move([:e, 8], "CS")
        end

        it "correctly unmoves the Black King" do
          expect(true_state.board.square([:g, 8]).piece).to be(nil)
        end

        it "correctly unmoves the correct Black Rook" do
          expect(true_state.board.square([:f, 8]).piece).to be(nil)
          expect(true_state.board.square([:h, 8]).piece)
            .to be_an_instance_of(Rook)
        end

        it "undos adjusting the unmoved status of the correct Black Rook" do
          expect(true_state.board.square([:h, 8]).piece.unmoved).to be(true)
        end
      end
    end
  end

  describe "#pawn_moved_two" do
    context "when given origin and target positions 2 apart" do
      context "with a Pawn in the target position square" do
        it "returns true" do
          true_state.make_move([:a, 2], [:a, 4])
          expect(true_state.pawn_moved_two([:a, 2], [:a, 4])).to be(true)
        end
      end

      context "with some other piece in the target position square" do
        it "returns false" do
          true_state.make_move([:a, 2], [:a, 4])
          true_state.make_move([:a, 4], [:a, 5])
          true_state.make_move([:a, 1], [:a, 2])
          true_state.make_move([:a, 2], [:a, 4])
          expect(true_state.pawn_moved_two([:a, 2], [:a, 4])).to be(false)
        end
      end
    end

    context "when given origin and target positions less than 2 apart" do
      context "with a Pawn in the target position square" do
        it "returns false" do
          true_state.make_move([:a, 2], [:a, 3])
          expect(true_state.pawn_moved_two([:a, 2], [:a, 3])).to be(false)
        end
      end

      context "with some other piece in the target position square" do
        it "returns false" do
          true_state.make_move([:a, 2], [:a, 4])
          true_state.make_move([:a, 1], [:a, 2])
          expect(true_state.pawn_moved_two([:a, 2], [:a, 3])).to be(false)
        end
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
