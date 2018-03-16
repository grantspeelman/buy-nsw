require 'rails_helper'

RSpec.describe Sellers::Applications::DocumentsForm do

  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::Applications::DocumentsForm.new(application: application, seller: seller) }

  let(:example_pdf) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf')
    )
  }
  let(:future_date) { Date.today + 1.year }
  let(:historical_date) { Date.today - 1.year }

  let(:atts) {
    {
      financial_statement: example_pdf,
      professional_indemnity_certificate: example_pdf,
      workers_compensation_certificate: example_pdf,
      financial_statement_expiry: future_date,
      professional_indemnity_certificate_expiry: future_date,
      workers_compensation_certificate_expiry: future_date,
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the financial statement is blank' do
    subject.validate(atts.merge(financial_statement: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:financial_statement]).to be_present
  end

  it 'is invalid when the professional indemnity certificate is blank' do
    subject.validate(atts.merge(professional_indemnity_certificate: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:professional_indemnity_certificate]).to be_present
  end

  it 'is invalid when the workers compensation certificate is blank' do
    subject.validate(atts.merge(workers_compensation_certificate: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:workers_compensation_certificate]).to be_present
  end

  context 'financial_statement_expiry' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(financial_statement_expiry: nil))

      expect(subject).to_not be_valid
      expect(subject.errors[:financial_statement_expiry]).to be_present
    end

    it 'is invalid when in the past' do
      subject.validate(atts.merge(financial_statement_expiry: historical_date))

      expect(subject).to_not be_valid
      expect(subject.errors[:financial_statement_expiry]).to be_present
    end
  end

  context 'professional_indemnity_certificate_expiry' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(professional_indemnity_certificate_expiry: nil))

      expect(subject).to_not be_valid
      expect(subject.errors[:professional_indemnity_certificate_expiry]).to be_present
    end

    it 'is invalid when in the past' do
      subject.validate(atts.merge(professional_indemnity_certificate_expiry: historical_date))

      expect(subject).to_not be_valid
      expect(subject.errors[:professional_indemnity_certificate_expiry]).to be_present
    end
  end

  context 'workers_compensation_certificate_expiry' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(workers_compensation_certificate_expiry: nil))

      expect(subject).to_not be_valid
      expect(subject.errors[:workers_compensation_certificate_expiry]).to be_present
    end

    it 'is invalid when in the past' do
      subject.validate(atts.merge(workers_compensation_certificate_expiry: historical_date))

      expect(subject).to_not be_valid
      expect(subject.errors[:workers_compensation_certificate_expiry]).to be_present
    end
  end

  context 'given multi-parameter dates' do
    it 'builds a valid expiry date' do
      subject.validate(
        atts.except(:financial_statement_expiry).merge(
          "financial_statement_expiry(3i)" => future_date.day,
          "financial_statement_expiry(2i)" => future_date.month,
          "financial_statement_expiry(1i)" => future_date.year,
        )
      )

      expect(subject).to be_valid
      expect(subject.financial_statement_expiry).to eq(future_date)
    end
  end

end
