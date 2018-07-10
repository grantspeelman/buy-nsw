require 'rails_helper'

RSpec.describe SellerVersion do

  describe "#abn" do
    it "should normalise a valid value" do
      seller = create(:approved_seller_version, abn: "24138089942")
      expect(seller.abn).to eq("24 138 089 942")
    end

    it "should do nothing to an already normalised value" do
      seller = create(:approved_seller_version, abn: "24 138 089 942")
      expect(seller.abn).to eq("24 138 089 942")
    end

    it "should not normalise an invalid value" do
      seller = create(:approved_seller_version, abn: "1234")
      expect(seller.abn).to eq("1234")
    end

    # This is actually testing the factory
    it "should create consecutive valid ABNs" do
      seller1 = build(:approved_seller_version)
      seller2 = build(:approved_seller_version)
      seller3 = build(:approved_seller_version)
      expect(ABN.valid?(seller1.abn)).to be_truthy
      expect(ABN.valid?(seller2.abn)).to be_truthy
      expect(ABN.valid?(seller3.abn)).to be_truthy
    end
  end
end
