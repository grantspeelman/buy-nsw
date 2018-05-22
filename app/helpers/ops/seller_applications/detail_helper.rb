module Ops::SellerApplications::DetailHelper
  def display_seller_list(type:, resource:)
    display_list(
      fields: seller_fields,
      resource_name: :seller_applications,
      type: type,
      resource: resource,
    )
  end

  def seller_fields
    {
      basic: [
        :name,
        :abn,
        :summary,
        :website_url,
        :linkedin_url
      ],
      industry: [
        :services,
      ],
      contacts: [
        :contact_name,
        :contact_email,
        :contact_phone,
        :representative_name,
        :representative_email,
        :representative_phone
      ],
      disclosures: [
        :investigations,
        :investigations_details,
        :legal_proceedings,
        :legal_proceedings_details,
        :insurance_claims,
        :insurance_claims_details,
        :conflicts_of_interest,
        :conflicts_of_interest_details,
        :other_circumstances,
        :other_circumstances_details,
      ],
      details: [
        :number_of_employees_text,
        :start_up,
        :sme,
        :not_for_profit,
        :australian_owned,
        :regional,
        :rural_remote,
        :travel,
        :indigenous,
        :disability,
        :female_owned,
      ],
      terms: [
        :agree,
        :agreed_at,
        :agreed_by,
      ]
    }
  end

  def government_experience_values(seller)
    labels = []
    keys = [
      :no_experience,
      :local_government_experience,
      :state_government_experience,
      :federal_government_experience,
      :international_government_experience,
    ]
    i18n_base = 'ops.seller_applications.fields.government_experience.values'

    keys.each do |key|
      labels << t("#{i18n_base}.#{key}") if seller.public_send("#{key}?")
    end

    labels.join('<br>').html_safe
  end

end
