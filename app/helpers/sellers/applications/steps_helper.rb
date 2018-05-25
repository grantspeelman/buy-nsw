module Sellers::Applications::StepsHelper
  def other_service_options
    Seller.services.options.reject {|(_, key)|
      key == 'cloud-services'
    }
  end
end
