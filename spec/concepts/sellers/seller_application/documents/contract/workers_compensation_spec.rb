require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Documents::Contract::WorkersCompensation do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Documents::Contract::WorkersCompensation.new(application: application, seller: seller) }

  let(:example_pdf) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf')
    )
  }
  let(:future_date) { Date.today + 1.year }
  let(:historical_date) { Date.today - 1.year }

  context 'for a seller not exempt from workers compensation insurance' do
    let(:atts) {
      {
        workers_compensation_certificate: example_pdf,
        workers_compensation_certificate_expiry: future_date,
        workers_compensation_exempt: false,
      }
    }

    it 'can save with valid attributes' do
      subject.validate(atts)

      expect(subject).to be_valid
      expect(subject.save).to eq(true)
    end

    it 'is invalid when the workers compensation certificate is blank' do
      subject.validate(atts.merge(workers_compensation_certificate: nil))

      expect(subject).to_not be_valid
      expect(subject.errors[:workers_compensation_certificate]).to be_present
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
  end

  context 'for a seller exempt from workers compensation insurance' do
    let(:atts) {
      {
        workers_compensation_certificate: nil,
        workers_compensation_certificate_expiry: nil,
        workers_compensation_exempt: true,
      }
    }

    it 'is valid when the certificate and expiry are blank' do
      subject.validate(atts)

      expect(subject).to be_valid
      expect(subject.save).to eq(true)
    end
  end
end
