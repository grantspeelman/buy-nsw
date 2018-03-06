class AddUploadsToSellers < ActiveRecord::Migration[5.1]
  def change
    change_table :sellers do |t|
      t.string :financial_statement
      t.string :professional_indemnity_certificate
      t.string :workers_compensation_certificate
    end
  end
end
