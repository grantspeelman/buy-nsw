module Sellers::SellerApplication::Contacts::Contract
  class Contacts < Base
    property :contact_name,          on: :seller
    property :contact_email,         on: :seller
    property :contact_phone,         on: :seller

    property :representative_name,   on: :seller
    property :representative_email,  on: :seller
    property :representative_phone,  on: :seller

    validation :default do
      required(:seller).schema do
        configure do
          def email?(value)
            value.match?(URI::MailTo::EMAIL_REGEXP)
          end
        end

        required(:contact_name).filled(:str?)
        required(:contact_email).filled(:str?, :email?)
        required(:contact_phone).filled(:str?)

        required(:representative_name).filled(:str?)
        required(:representative_email).filled(:str?, :email?)
        required(:representative_phone).filled(:str?)
      end
    end
  end
end
