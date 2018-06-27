require 'rails_helper'

RSpec.describe BuyerApplicationMailer, type: :mailer do

  describe '#manager_approval_email' do
    let(:application) { create(:awaiting_manager_approval_buyer_application) }
    let(:mail) { BuyerApplicationMailer.with(application: application).manager_approval_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Your approval required for #{application.user.email}")
      expect(mail.to).to contain_exactly(application.manager_email)
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(application.buyer.name)
      expect(mail.body.encoded).to match(application.user.email)

      expect(mail.body.encoded).to match(application.manager_approval_token)
      expect(mail.body.encoded).to match('Approve account')
    end
  end

  describe '#application_approved_email' do
    let(:application) { create(:approved_buyer_application) }
    let(:mail) { BuyerApplicationMailer.with(application: application).application_approved_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Welcome to the buy.nsw community")
      expect(mail.to).to contain_exactly(application.user.email)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.decision_body)
    end
  end

  describe '#application_rejected_email' do
    let(:application) { create(:rejected_buyer_application) }
    let(:mail) { BuyerApplicationMailer.with(application: application).application_rejected_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Feedback on your buy.nsw application")
      expect(mail.to).to contain_exactly(application.user.email)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.decision_body)
    end
  end

end
