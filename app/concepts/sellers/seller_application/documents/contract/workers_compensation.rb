module Sellers::SellerApplication::Documents::Contract
  class WorkersCompensation < Base
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :workers_compensation_certificate,        on: :seller
    property :workers_compensation_certificate_expiry, on: :seller, multi_params: true

    validation :default, inherit: true do
      required(:seller).schema do
        required(:workers_compensation_certificate).filled(:file?)
        required(:workers_compensation_certificate_expiry).filled(:date?, :in_future?)
      end
    end
  end
end
