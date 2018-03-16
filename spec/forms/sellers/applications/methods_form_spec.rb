require 'rails_helper'

RSpec.describe Sellers::Applications::MethodsForm do

  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::Applications::MethodsForm.new(application: application, seller: seller) }

  let(:atts) {
    {
      tools: 'Free-text',
      methodologies: 'Free-text',
      technologies: 'Free-text',
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the tools field is blank' do
    subject.validate(atts.merge(tools: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:tools]).to be_present
  end

  it 'is invalid when the methodologies field is blank' do
    subject.validate(atts.merge(methodologies: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:methodologies]).to be_present
  end

  it 'is valid when the technologies field is blank' do
    subject.validate(atts.merge(technologies: nil))

    expect(subject).to be_valid
  end
end
