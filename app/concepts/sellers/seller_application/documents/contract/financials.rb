module Sellers::SellerApplication::Documents::Contract
  class Financials < Base
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :financial_statement,        on: :seller
    property :financial_statement_expiry, on: :seller, multi_params: true

    validation :default, inherit: true do
      required(:seller).schema do
        required(:financial_statement).filled(:file?)
        required(:financial_statement_expiry).filled(:date?)
      end
    end
  end
end
