require 'rails_helper'

RSpec.describe SellerApplicationMailer, type: :mailer do

  describe '#application_approved_email' do
    let(:application) { create(:approved_seller_version) }
    let(:mail) { SellerApplicationMailer.with(application: application).application_approved_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Your application has been successful")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(*application.owners.map(&:email))
    end

    it 'say nice things' do
      expect(mail.body.encoded).to match('application has been successful')
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(application.name)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.response)
    end

    # NOTE: This spec is skipped as we've removed Premailer from the test
    # environment for performance reasons.
    #
    skip 'should not have a style tag in the html after running premailer' do
      Premailer::Rails::Hook.perform(mail)
      StyleTagRemoverInterceptor.delivering_email(mail)
      doc = Nokogiri::HTML(mail.html_part.body.to_s)
      expect(doc.search('style')).to be_empty
    end
  end

  describe "#application_rejected_email" do
    let(:application) { create(:rejected_seller_version) }
    let(:mail) { SellerApplicationMailer.with(application: application).application_rejected_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Sorry, your application has not been approved")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(*application.owners.map(&:email))
    end

    it 'breaks the news gently' do
      expect(mail.body.encoded).to match('sorry')
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(application.name)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.response)
    end
  end

  describe "#application_return_to_applicant_email" do
    let(:application) { create(:returned_to_applicant_seller_version) }
    let(:mail) { SellerApplicationMailer.with(application: application).application_return_to_applicant_email }

    it 'renders the headers' do
      expect(mail.subject).to match("Your application needs some changes before it can be approved")
      # TODO: Probably want the person's name in there too
      expect(mail.to).to contain_exactly(*application.owners.map(&:email))
    end

    it 'lets them know that they need to make changes' do
      expect(mail.body.encoded).to match('update your application')
    end

    it 'should include the name of the seller' do
      expect(mail.body.encoded).to match(application.name)
    end

    it 'should include the feedback from the reviewer' do
      expect(mail.body.encoded).to match(application.response)
    end
  end

end
