class AddAdditionalSellerFields < ActiveRecord::Migration[5.1]
  def change
    change_table :sellers do |t|
      t.date :financial_statement_expiry
      t.date :professional_indemnity_certificate_expiry
      t.date :workers_compensation_certificate_expiry

      t.boolean :agree
      t.datetime :agreed_at
      t.integer :agreed_by
    end
  end
end
