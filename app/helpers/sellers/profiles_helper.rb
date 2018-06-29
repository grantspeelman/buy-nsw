module Sellers::ProfilesHelper
  def seller_profile_tags(seller)
    content_tag(:ul, class: 'tags') {
      [:start_up, :sme, :indigenous, :not_for_profit, :govdc, :regional].select {|tag|
        seller.public_send(tag) == true
      }.map {|tag|
        content_tag(:li, I18n.t("sellers.tags.#{tag}"), class: "tag-#{tag.to_s.dasherize}")
      }.join(' ').html_safe
    }.html_safe
  end

  def abn_lookup_url(abn)
    "https://abr.business.gov.au/SearchByAbn.aspx?SearchText=#{URI::encode(formatted_abn(abn))}"
  end

  def formatted_abn(abn)
    abn = (abn || '').gsub(' ','')

    abn = abn.insert(2, ' ') if abn.length > 2
    abn = abn.insert(6, ' ') if abn.length > 6
    abn = abn.insert(10, ' ') if abn.length > 10

    abn
  end
end
