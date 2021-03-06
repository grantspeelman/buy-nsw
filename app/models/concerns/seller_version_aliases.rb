module Concerns::SellerVersionAliases
  extend ActiveSupport::Concern

  FIELDS = [
    :name,
    :abn,
    :summary,
    :services,
    :govdc,
    :website_url,
    :linkedin_url,
    :number_of_employees,
    :number_of_employees_text,
    :corporate_structure,
    :corporate_structure_text,
    :start_up,
    :sme,
    :not_for_profit,
    :regional,
    :disability,
    :female_owned,
    :indigenous,
    :australian_owned,
    :no_experience,
    :local_government_experience,
    :state_government_experience,
    :federal_government_experience,
    :international_government_experience,
    :contact_name,
    :contact_email,
    :contact_phone,
    :representative_name,
    :representative_email,
    :representative_phone,
    :representative_position,
    :investigations,
    :legal_proceedings,
    :insurance_claims,
    :conflicts_of_interest,
    :other_circumstances,
    :receivership,
    :investigations_details,
    :legal_proceedings_details,
    :insurance_claims_details,
    :conflicts_of_interest_details,
    :other_circumstances_details,
    :receivership_details,
    :financial_statement_expiry,
    :professional_indemnity_certificate_expiry,
    :workers_compensation_certificate_expiry,
    :workers_compensation_exempt,
    :product_liability_certificate_expiry,
    :agree,
    :agreed_at,
    :agreed_by_id,
  ]

  included do
    FIELDS.each do |field|
      define_method(field) do |*args, &block|
        if first_version.present?
          first_version.public_send(field, *args, &block)
        end
      end
    end
  end

end
