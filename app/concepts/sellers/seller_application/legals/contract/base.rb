module Sellers::SellerApplication::Legals::Contract
  class Base < Reform::Form
    include Concerns::Contracts::Composition
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Concerns::Contracts::SellerApplication
    include Forms::ValidationHelper
  end
end
