class AddFieldsToBuyer < ActiveRecord::Migration[5.1]
  def change
    add_column :buyers, :state, :string, null: false
    add_column :buyers, :name, :string
    add_column :buyers, :employment_status, :string
    add_column :buyers, :terms_agreed, :boolean
    add_column :buyers, :terms_agreed_at, :datetime

    add_column :buyer_applications, :manager_name, :string
    add_column :buyer_applications, :manager_email, :string
    add_column :buyer_applications, :manager_approved_at, :datetime
  end
end
