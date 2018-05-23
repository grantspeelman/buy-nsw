class AddCorporateStructureToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :corporate_structure, :string
  end
end
