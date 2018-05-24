class AddAudiencesOtherToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :audiences_other, :text
  end
end
