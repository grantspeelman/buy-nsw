class RemoveTermsAgreedFromBuyers < ActiveRecord::Migration[5.1]
  def change
    remove_column :buyers, :terms_agreed, :boolean
    remove_column :buyers, :terms_agreed_at, :datetime
  end
end
