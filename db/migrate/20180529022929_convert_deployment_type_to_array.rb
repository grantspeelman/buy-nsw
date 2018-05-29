class ConvertDeploymentTypeToArray < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :deployment_model, :string
    add_column :products, :deployment_model, :text, array: true, default: []
  end
end
