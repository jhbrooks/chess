require "spec_helper"

describe Player do
  let(:player) { Player.new(:p1, :White) }

  describe ".new" do
    context "when given 2 arguments (name, color)" do
      it "returns a Player object" do
        expect(player).to be_an_instance_of(Player)
      end
    end

    context "when given fewer than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Player.new }.to raise_error(ArgumentError)
      end
    end

    context "when given more than 2 arguments" do
      it "raises an ArgumentError" do
        expect { Player.new(1, 2, 3) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#name" do
    it "returns the correct name" do
      expect(player.name).to eq(:p1)
    end
  end

  describe "#color" do
    it "returns the correct color" do
      expect(player.color).to eq(:White)
    end
  end

  describe "#in_check" do
    it "returns false after initialization" do
      expect(player.in_check).to be(false)
    end
  end

  describe "#in_check=" do
    it "correctly sets the in_check attribute" do
      player.in_check = true
      expect(player.in_check).to be(true)
    end
  end

  describe "#to_s" do
    it "returns a formatted string representing the Player" do
      expect(player.to_s).to eq("White (p1)")
    end
  end
end
