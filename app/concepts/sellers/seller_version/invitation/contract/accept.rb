module Sellers::SellerVersion::Invitation::Contract
  class Accept < Reform::Form
    property :password
    property :password_confirmation, virtual: true

    validation :default, with: { form: true } do
      configure do
        option :form

        def same_password?(value)
          value == form.password
        end
      end

      required(:password).filled
      required(:password_confirmation).filled(:same_password?)
    end
  end
end
