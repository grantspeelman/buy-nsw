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

    # This is actually testing the factory
    it "should create consecutive valid ABNs" do
      seller1 = build(:inactive_seller_with_full_profile)
      seller2 = build(:inactive_seller_with_full_profile)
      seller3 = build(:inactive_seller_with_full_profile)
      expect(ABN.valid?(seller1.abn)).to be_truthy
      expect(ABN.valid?(seller2.abn)).to be_truthy
      expect(ABN.valid?(seller3.abn)).to be_truthy
    end
  end
end
