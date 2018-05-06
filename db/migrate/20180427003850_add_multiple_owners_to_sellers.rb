class AddMultipleOwnersToSellers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :seller_id, :integer

    User.reset_column_information
    Seller.all.each do |s|
      u = User.find(s.owner_id)
      u.update_attribute(:seller_id, s.id)
    end

    remove_column :sellers, :owner_id
  end

  def down
    add_column :sellers, :owner_id, :integer

    User.all.each do |u|
      next if u.seller_id.blank?

      s = Seller.find(u.seller_id)
      s.update_attribute(:owner_id, u.id)
    end

    remove_column :users, :seller_id, :integer
    change_column_null :sellers, :owner_id, false
  end
end
