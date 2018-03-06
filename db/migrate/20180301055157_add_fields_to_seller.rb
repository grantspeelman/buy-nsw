class AddFieldsToSeller < ActiveRecord::Migration[5.1]
  def change
    change_table :sellers do |t|
      # Business details
      #
      t.string :abn
      t.text   :summary
      t.string :website_url
      t.string :linkedin_url

      # Business info
      #
      t.string :number_of_employees

      t.boolean :start_up
      t.boolean :sme
      t.boolean :not_for_profit

      t.boolean :regional
      t.boolean :travel

      t.boolean :disability
      t.boolean :female_owned
      t.boolean :indigenous

      t.boolean :no_experience
      t.boolean :local_government_experience
      t.boolean :state_government_experience
      t.boolean :federal_government_experience
      t.boolean :international_government_experience

      # Contacts
      #
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.string :representative_name
      t.string :representative_email
      t.string :representative_phone

      # Disclosures
      #
      t.boolean :structural_changes
      t.boolean :investigations
      t.boolean :legal_proceedings
      t.boolean :insurance_claims
      t.boolean :conflicts_of_interest
      t.boolean :other_circumstances

      t.text :structural_changes_details
      t.text :investigations_details
      t.text :legal_proceedings_details
      t.text :insurance_claims_details
      t.text :conflicts_of_interest_details
      t.text :other_circumstances_details

      # Methods
      #
      t.text :tools
      t.text :methodologies
      t.text :technologies

      # Recognition
      #
      t.text :accreditations,      array: true, default: []
      t.text :awards,              array: true, default: []
      t.text :industry_engagement, array: true, default: []

      # Services
      #
      t.text :services, array: true, default: []
    end
  end
end
