require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Profile::Contract::Basics do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Profile::Contract::Basics.new(application: application, seller: seller) }

  let(:atts) {
    {
      summary: 'Summary',
      website_url: 'http://example.org',
      linkedin_url: 'http://linkedin.com/example',
    }
  }

  it 'can save with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the summary is blank' do
    subject.validate(atts.merge(summary: ''))

    expect(subject).to_not be_valid
    expect(subject.errors[:summary]).to be_present
  end

  it 'is invalid when the website URL is blank' do
    subject.validate(atts.merge(website_url: ''))

    expect(subject).to_not be_valid
    expect(subject.errors[:website_url]).to be_present
  end

end
