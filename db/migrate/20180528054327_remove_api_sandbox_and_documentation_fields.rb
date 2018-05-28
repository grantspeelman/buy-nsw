class RemoveApiSandboxAndDocumentationFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :api_documentation, :boolean
    remove_column :products, :api_sandbox, :boolean
  end
end
