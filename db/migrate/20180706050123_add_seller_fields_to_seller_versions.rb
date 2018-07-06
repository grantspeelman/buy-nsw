class AddSellerFieldsToSellerVersions < ActiveRecord::Migration[5.1]
  def change
    change_table :seller_versions do |t|
      t.string :name
      t.string :abn
      t.text :summary

      t.text :services, default: [], array: true
      t.boolean :govdc

      t.string :website_url
      t.string :linkedin_url

      t.string :number_of_employees
      t.string :corporate_structure
      t.boolean :start_up
      t.boolean :sme
      t.boolean :not_for_profit
      t.boolean :regional
      t.boolean :disability
      t.boolean :female_owned
      t.boolean :indigenous
      t.boolean :australian_owned

      t.boolean :no_experience
      t.boolean :local_government_experience
      t.boolean :state_government_experience
      t.boolean :federal_government_experience
      t.boolean :international_government_experience

      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :representative_name
      t.string :representative_email
      t.string :representative_phone
      t.string :representative_position

      t.boolean :investigations
      t.boolean :legal_proceedings
      t.boolean :insurance_claims
      t.boolean :conflicts_of_interest
      t.boolean :other_circumstances
      t.boolean :receivership

      t.text :investigations_details
      t.text :legal_proceedings_details
      t.text :insurance_claims_details
      t.text :conflicts_of_interest_details
      t.text :other_circumstances_details
      t.text :receivership_details

      t.date :financial_statement_expiry
      t.date :professional_indemnity_certificate_expiry
      t.date :workers_compensation_certificate_expiry
      t.boolean :workers_compensation_exempt
      t.date :product_liability_certificate_expiry

      t.boolean :agree
      t.datetime :agreed_at
      t.integer :agreed_by_id
    end
  end
end
