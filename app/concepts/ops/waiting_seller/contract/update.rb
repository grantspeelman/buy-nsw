module Ops::WaitingSeller::Contract
  class Update < Reform::Form
    include Forms::ValidationHelper

    property :name
    property :abn
    property :address
    property :suburb
    property :postcode
    property :state
    property :country
    property :contact_name
    property :contact_email
    property :contact_position
    property :website_url

    validation :default, inherit: true, with: {form: true} do
      configure do
        option :form

        def waiting_seller_not_existing_user?(contact_email)
          User.where(email: contact_email).empty?
        end

        def waiting_seller_unique_contact_email?(value)
          WaitingSeller.where.not(id: form.model.id).where(contact_email: value).empty?
        end
      end

      required(:name).filled(:str?)
      required(:abn).filled(:str?)
      required(:address).filled(:str?)
      required(:suburb).filled(:str?)
      required(:postcode).filled(:str?)
      required(:state).filled(in_list?: SellerAddress.state.values)
      required(:country).filled(:str?)
      required(:contact_name).filled(:str?)
      required(:contact_position).filled(:str?)
      required(:website_url).filled(:str?)

      required(:contact_email).filled(:str?)

      rule(contact_email: [:contact_email]) do |email|
        email.filled? > email.waiting_seller_not_existing_user?
      end
      rule(contact_email: [:contact_email]) do |email|
        email.filled? > email.waiting_seller_unique_contact_email?
      end
    end
  end
end
