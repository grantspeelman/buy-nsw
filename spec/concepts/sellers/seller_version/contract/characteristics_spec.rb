require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Contract::Characteristics do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_version, seller: seller) }

  subject { described_class.new(application: application, seller: seller) }

  let(:atts) {
    {
      number_of_employees: '2to4',
      corporate_structure: 'standalone',
      start_up: true,
      sme: true,
      not_for_profit: false,
      australian_owned: true,
      regional: true,
      disability: false,
      female_owned: true,
      indigenous: false,
      no_experience: false,
      local_government_experience: true,
      state_government_experience: true,
      federal_government_experience: false,
      international_government_experience: true,
    }
  }

  it 'can save with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the number of employees is blank' do
    subject.validate(atts.merge(number_of_employees: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:number_of_employees]).to be_present
  end

  it 'is invalid when the number of employees is not a valid value' do
    subject.validate(atts.merge(number_of_employees: 'something else'))

    expect(subject).to_not be_valid
    expect(subject.errors[:number_of_employees]).to be_present
  end
end
