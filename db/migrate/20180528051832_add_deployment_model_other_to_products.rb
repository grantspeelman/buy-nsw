class AddDeploymentModelOtherToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :deployment_model_other, :text
  end
end
