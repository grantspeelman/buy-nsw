class AddReceivershipToSellers < ActiveRecord::Migration[5.1]
  def change
    change_table :sellers do |t|
      t.boolean :receivership
      t.text :receivership_details
    end
  end
end
