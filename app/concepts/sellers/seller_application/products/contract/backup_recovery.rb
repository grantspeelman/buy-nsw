module Sellers::SellerApplication::Products::Contract
  class BackupRecovery < Base
    property :backup_capability, on: :product
    property :backup_scheduling_type, on: :product
    property :backup_recovery_type, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:backup_capability).filled(in_list?: Product.backup_capability.values)
        required(:backup_scheduling_type).filled(in_list?: Product.backup_scheduling_type.values)
        required(:backup_recovery_type).filled(in_list?: Product.backup_recovery_type.values)
      end
    end
  end
end
