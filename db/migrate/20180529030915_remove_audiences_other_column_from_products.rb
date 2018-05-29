class RemoveAudiencesOtherColumnFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :audiences_other, :text
  end
end
