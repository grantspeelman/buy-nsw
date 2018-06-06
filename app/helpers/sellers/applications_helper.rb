module Sellers::ApplicationsHelper
  def other_service_options
    Seller.services.options.reject {|(_, key)|
      key == 'cloud-services'
    }
  end

  def disclosures_text_for(application)
    fields = [ :investigations, :legal_proceedings, :insurance_claims, :conflicts_of_interest, :other_circumstances ]

    values = fields.select {|field| application.seller.send(field) == true }

    if values.any?
      pluralize(values.size, 'disclosure')
    else
      'None'
    end
  end

  def business_identifier_text_for(application)
    base = "activemodel.attributes.sellers.seller_application.profile.contract.characteristics"
    fields = [
      :start_up,
      :sme,
      :not_for_profit,
      :regional,
      :rural_remote,
      :travel,
      :disability,
      :australian_owned,
      :female_owned,
      :indigenous,
    ]

    selected = fields.select {|field| application.seller.send(field) == true }
    labels = selected.map {|field|
      I18n.t("#{base}.#{field}")
    }

    labels.sort.join('<br>').html_safe
  end

  def legals_disabled_message(application)
    if application.seller.representative_email.blank?
      t('sellers.applications.legals.errors.no_representative')
    elsif current_user.email != application.seller.representative_email
      t('sellers.applications.legals.errors.incorrect_user_html',
          invite_link: new_sellers_application_invitation_path(application)).html_safe
    else
      return false
    end
  end
  
end
