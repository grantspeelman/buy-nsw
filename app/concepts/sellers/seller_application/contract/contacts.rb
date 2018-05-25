module Sellers::SellerApplication::Contract
  class Contacts < Base
    property :contact_name,          on: :seller
    property :contact_email,         on: :seller
    property :contact_phone,         on: :seller

    property :representative_name,     on: :seller
    property :representative_email,    on: :seller
    property :representative_phone,    on: :seller
    property :representative_position, on: :seller

    validation :default, inherit: true do
      required(:seller).schema do
        required(:contact_name).filled(:str?)
        required(:contact_email).filled(:str?, :email?)
        required(:contact_phone).filled(:str?)

        required(:representative_name).filled(:str?)
        required(:representative_email).filled(:str?, :email?)
        required(:representative_phone).filled(:str?)
        required(:representative_position).filled(:str?)
      end
    end
  end
end
