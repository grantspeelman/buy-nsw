class Buyers::ProductOrder::Contract < Reform::Form
  property :estimated_contract_value
  property :contacted_seller
  property :purchased_cloud_before

  validation do
    required(:estimated_contract_value).filled(:number?)
    required(:contacted_seller).filled
    required(:purchased_cloud_before).filled
  end
end
