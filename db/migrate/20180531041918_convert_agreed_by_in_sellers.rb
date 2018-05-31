class ConvertAgreedByInSellers < ActiveRecord::Migration[5.1]
  def change
    rename_column :sellers, :agreed_by, :agreed_by_id
  end
end
