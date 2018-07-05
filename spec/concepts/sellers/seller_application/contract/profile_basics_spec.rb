require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Contract::ProfileBasics do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_version, seller: seller) }

  subject { Sellers::SellerApplication::Contract::ProfileBasics.new(application: application, seller: seller) }

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

  it 'is invalid when the website URL is blank' do
    subject.validate(atts.merge(website_url: ''))

    expect(subject).to_not be_valid
    expect(subject.errors[:website_url]).to be_present
  end

  it 'is invalid when a bad website URL is given' do
    subject.validate(atts.merge(website_url: 'foo'))

    expect(subject).to_not be_valid
    expect(subject.errors[:website_url]).to be_present
  end

  it 'is invalid when a bad linkedin url is given' do
    subject.validate(atts.merge(linkedin_url: 'foo'))

    expect(subject).to_not be_valid
    expect(subject.errors[:linkedin_url]).to be_present
  end

  context 'summary' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(summary: ''))

      expect(subject).to_not be_valid
      expect(subject.errors[:summary]).to be_present
    end

    it 'is valid when less than 50 words' do
      summary = (1..49).map {|n| 'word' }.join(' ')
      subject.validate(atts.merge(summary: summary))

      expect(subject).to be_valid
    end

    it 'is valid when 50 words' do
      summary = (1..50).map {|n| 'word' }.join(' ')
      subject.validate(atts.merge(summary: summary))

      expect(subject).to be_valid
    end

    it 'is invalid when longer than 50 words' do
      summary = (1..51).map {|n| 'word' }.join(' ')
      subject.validate(atts.merge(summary: summary))

      expect(subject).to_not be_valid
      expect(subject.errors[:summary]).to be_present
    end
  end

end
