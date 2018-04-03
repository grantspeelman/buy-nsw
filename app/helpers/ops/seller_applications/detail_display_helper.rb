module Ops::SellerApplications::DetailDisplayHelper
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
        :industry,
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
        :structural_changes,
        :structural_changes_details,
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

  def display_list(type:, resource:)
    content_tag(:dl, id: type) {
      seller_fields[type].map {|field|
        [
          content_tag(:dt, display_label_for(type, field)) +
          content_tag(:dd, display_value_for(resource, field))
        ]
      }.flatten.join.html_safe
    }
  end

  def display_label_for(type, field)
    t("ops.seller_applications.fields.#{field}.name", default: field)
  end

  def display_value_for(resource, field)
    value = resource.public_send(field)

    value = 'yes' if value.is_a?(TrueClass)
    value = 'no' if value.is_a?(FalseClass)
    value = extract_enumerize_set(value) if value.is_a?(Enumerize::Set)

    value = sanitize(value)

    if value.present?
      case field
      when :abn then
        link_to(formatted_abn(value), abn_lookup_url(value))
      when :linkedin_url, :website_url then link_to(value, value)
      else
        value
      end
    else
      content_tag :em, 'blank'
    end
  end

  def extract_enumerize_set(set)
    set.map {|key| key.text }.join('<br>').html_safe
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
