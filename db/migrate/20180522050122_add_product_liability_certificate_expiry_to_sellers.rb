class AddProductLiabilityCertificateExpiryToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :product_liability_certificate_expiry, :date
  end
end
