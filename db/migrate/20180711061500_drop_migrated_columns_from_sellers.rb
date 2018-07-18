class DropMigratedColumnsFromSellers < ActiveRecord::Migration[5.1]
  def change
    remove_column :sellers, :name, :string
    remove_column :sellers, :abn, :string
    remove_column :sellers, :summary, :text

    remove_column :sellers, :services, :text, default: [], array: true
    remove_column :sellers, :govdc, :boolean

    remove_column :sellers, :website_url, :string
    remove_column :sellers, :linkedin_url, :string

    remove_column :sellers, :number_of_employees, :string
    remove_column :sellers, :corporate_structure, :string
    remove_column :sellers, :start_up, :boolean
    remove_column :sellers, :sme, :boolean
    remove_column :sellers, :not_for_profit, :boolean
    remove_column :sellers, :regional, :boolean
    remove_column :sellers, :disability, :boolean
    remove_column :sellers, :female_owned, :boolean
    remove_column :sellers, :indigenous, :boolean
    remove_column :sellers, :australian_owned, :boolean

    remove_column :sellers, :no_experience, :boolean
    remove_column :sellers, :local_government_experience, :boolean
    remove_column :sellers, :state_government_experience, :boolean
    remove_column :sellers, :federal_government_experience, :boolean
    remove_column :sellers, :international_government_experience, :boolean

    remove_column :sellers, :contact_name, :string
    remove_column :sellers, :contact_email, :string
    remove_column :sellers, :contact_phone, :string
    remove_column :sellers, :representative_name, :string
    remove_column :sellers, :representative_email, :string
    remove_column :sellers, :representative_phone, :string
    remove_column :sellers, :representative_position, :string

    remove_column :sellers, :investigations, :boolean
    remove_column :sellers, :legal_proceedings, :boolean
    remove_column :sellers, :insurance_claims, :boolean
    remove_column :sellers, :conflicts_of_interest, :boolean
    remove_column :sellers, :other_circumstances, :boolean
    remove_column :sellers, :receivership, :boolean

    remove_column :sellers, :investigations_details, :text
    remove_column :sellers, :legal_proceedings_details, :text
    remove_column :sellers, :insurance_claims_details, :text
    remove_column :sellers, :conflicts_of_interest_details, :text
    remove_column :sellers, :other_circumstances_details, :text
    remove_column :sellers, :receivership_details, :text

    remove_column :sellers, :financial_statement_expiry, :date
    remove_column :sellers, :professional_indemnity_certificate_expiry, :date
    remove_column :sellers, :workers_compensation_certificate_expiry, :date
    remove_column :sellers, :workers_compensation_exempt, :boolean
    remove_column :sellers, :product_liability_certificate_expiry, :date

    remove_column :sellers, :agree, :boolean
    remove_column :sellers, :agreed_at, :datetime
    remove_column :sellers, :agreed_by_id, :integer

    remove_column :sellers, :tools, :text
    remove_column :sellers, :methodologies, :text
    remove_column :sellers, :technologies, :text
  end
end
