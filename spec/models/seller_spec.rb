require 'rails_helper'

RSpec.describe Seller do

  describe "#abn" do
    it "should normalise a valid value" do
      seller = create(:inactive_seller_with_full_profile, abn: "24138089942")
      expect(seller.abn).to eq("24 138 089 942")
    end

    it "should do nothing to an already normalised value" do
      seller = create(:inactive_seller_with_full_profile, abn: "24 138 089 942")
      expect(seller.abn).to eq("24 138 089 942")
    end
  end
end
