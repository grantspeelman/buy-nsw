module Sellers::SellerVersion::Products::Contract
  class OperationalSecurity < Base
    property :change_management_processes, on: :product
    property :change_management_approach, on: :product
    property :vulnerability_processes, on: :product
    property :vulnerability_approach, on: :product
    property :protective_monitoring_processes, on: :product
    property :protective_monitoring_approach, on: :product
    property :incident_management_processes, on: :product
    property :incident_management_approach, on: :product
    property :access_control_testing_frequency, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:change_management_processes).filled(in_list?: Product.change_management_processes.values)
        required(:change_management_approach).filled(:str?)
        required(:vulnerability_processes).filled(in_list?: Product.vulnerability_processes.values)
        required(:vulnerability_approach).filled(:str?)
        required(:protective_monitoring_processes).filled(in_list?: Product.protective_monitoring_processes.values)
        required(:protective_monitoring_approach).filled(:str?)
        required(:incident_management_processes).filled(in_list?: Product.incident_management_processes.values)
        required(:incident_management_approach).filled(:str?)
        required(:access_control_testing_frequency).filled(in_list?: Product.access_control_testing_frequency.values)
      end
    end
  end
end
