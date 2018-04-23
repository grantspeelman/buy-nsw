require 'rails_helper'

RSpec.describe 'Sellers::SellerApplication::Contract::Recognition' do
  skip "is skipped pending update of seller onboarding contract specs" do
    let(:seller) { create(:inactive_seller) }
    let(:application) { create(:seller_application, seller: seller) }

    subject { Sellers::SellerApplication::Contract::Recognition.new(application: application, seller: seller) }

    let(:atts) {
      {
        accreditations: [
          { accreditation: 'Certified Test Case' },
        ],
        awards: [
          { award: 'Test Case of the Year' },
        ],
        engagements: [
          { engagement: 'Test Case Board Member' },
        ],
      }
    }

    it 'can save and create nested objects with valid attributes' do
      subject.validate(atts)

      expect(subject).to be_valid
      expect(subject.save).to eq(true)
      seller.reload

      expect(seller.accreditations.count).to eq(1)
      expect(seller.awards.count).to eq(1)
      expect(seller.engagements.count).to eq(1)
    end

    it 'ignores any nested children where text is blank' do
      subject.validate(atts.merge(
        accreditations: [
          { accreditation: 'Item 1' },
          { accreditation: '' },
          { accreditation: 'Item 3' },
        ]
      ))
      subject.save

      expect(seller.accreditations.count).to eq(2)
      expect(seller.accreditations.map(&:accreditation)).to contain_exactly(
        'Item 1', 'Item 3'
      )
    end

    it 'updates a nested child given an ID' do
      existing = create(:seller_accreditation, seller: seller, accreditation: 'Existing')

      subject.validate(atts.merge(
        accreditations: [
          { id: existing.id, accreditation: 'Updated' },
        ]
      ))
      subject.save
      existing.reload

      expect(existing.accreditation).to eq('Updated')
    end

    it 'destroys a nested child given an ID and a blank value' do
      existing = create(:seller_accreditation, seller: seller, accreditation: 'Existing')

      subject.validate(atts.merge(
        accreditations: [
          { id: existing.id, accreditation: '' },
        ]
      ))
      subject.save
      seller.reload

      expect(seller.accreditations.count).to eq(0)
    end

    context 'with _attributes keys' do
      it 'can create nested children' do
        atts = {
          "accreditations_attributes" => {
            "0" => { accreditation: 'Certified Test Case' },
          },
          "awards_attributes" => {
            "0" => { award: 'Test Case of the Year' },
          },
          "engagements_attributes" => {
            "0" => { engagement: 'Test Case Board Member' },
          },
        }
        subject.validate(atts)
        subject.save
        seller.reload

        expect(seller.accreditations.count).to eq(1)
        expect(seller.awards.count).to eq(1)
        expect(seller.engagements.count).to eq(1)
      end

      it 'can update nested children' do
        existing = create(:seller_accreditation, seller: seller, accreditation: 'Existing')

        subject.validate({
          "accreditations_attributes" => {
            "0" => { id: existing.id, accreditation: 'Updated' },
          }
        })
        subject.save
        existing.reload

        expect(existing.accreditation).to eq('Updated')
      end

      it 'can destroy nested children given a blank string' do
        existing = create(:seller_accreditation, seller: seller, accreditation: 'Existing')

        subject.validate({
          "accreditations_attributes" => {
            "0" => { id: existing.id, accreditation: '' },
          }
        })
        subject.save
        seller.reload

        expect(seller.accreditations.count).to eq(0)
      end
    end
  end
end
