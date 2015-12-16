require "spec_helper"

describe Player do
  let(:player) { Player.new(:p1, "White") }

  describe "#new" do
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
      expect(player.color).to eq("White")
    end
  end
end
