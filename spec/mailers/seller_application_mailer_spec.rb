require 'rails_helper'

RSpec.describe SellerApplicationMailer, type: :mailer do

  describe '#application_approved_email' do
    let(:application) { create(:approved_seller_application) }
    let(:mail) { SellerApplicationMailer.with(application: application).application_approved_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Congratulations, your application has been approved")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(*application.owners.map(&:email))
    end

    it 'say nice things' do
      expect(mail.body.encoded).to match('Congratulations')
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(application.seller.name)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.response)
    end
  end

  describe "#application_rejected_email" do
    let(:application) { create(:rejected_seller_application) }
    let(:mail) { SellerApplicationMailer.with(application: application).application_rejected_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Sorry, your application has not been approved")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(*application.owners.map(&:email))
    end

    it 'breaks the news gently' do
      expect(mail.body.encoded).to match('Sorry')
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(application.seller.name)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.response)
    end
  end

  describe "#application_return_to_applicant_email" do
    let(:application) { create(:returned_to_applicant_seller_application) }
    let(:mail) { SellerApplicationMailer.with(application: application).application_return_to_applicant_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Your application needs some changes before it can be approved")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(*application.owners.map(&:email))
    end

    it 'lets them know that they need to make changes' do
      expect(mail.body.encoded).to match('needs some changes')
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(application.seller.name)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.response)
    end
  end

end
