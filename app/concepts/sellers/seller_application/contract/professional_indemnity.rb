module Sellers::SellerApplication::Contract
  class ProfessionalIndemnity < Base
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :professional_indemnity_certificate_file,   on: :seller
    property :professional_indemnity_certificate_expiry, on: :seller, multi_params: true
    property :remove_professional_indemnity_certificate, on: :seller

    validation :default, inherit: true do
      required(:seller).schema do
        required(:professional_indemnity_certificate_file).filled(:file?)
        required(:professional_indemnity_certificate_expiry).filled(:date?, :in_future?)
      end
    end

    def started?
      super do |key, value|
        next if key == 'professional_indemnity_certificate'
        value.present?
      end
    end
  end
end
