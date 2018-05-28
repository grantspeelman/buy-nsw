class UpdateSupportFieldsOnProduct < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :support_hours, :support_options_additional_cost
  end
end
