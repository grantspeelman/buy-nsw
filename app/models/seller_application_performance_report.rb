class SellerApplicationPerformanceReport

  def statistics
    @statistics ||= build_statistics
  end

private
  def lookup_translation(key)
    I18n.translate("performance.seller_applications.progress.#{key}", default: key.to_s)
  end

  def keys
    [
      :offering,
      :business_details,
      :contact_details,
      :characteristics,
      :addresses,
      :disclosures,
      :financial_statement,
      :product_liability,
      :professional_indemnity,
      :workers_compensation,
      :products,
      :terms_agreed,
    ]
  end

  def build_statistics
    return {} unless Seller.any?

    tuples = keys.map {|key|
      [
        lookup_translation(key),
        self.send(key)
      ]
    }
    Hash[tuples]
  end

  def in_progress_sellers
    @in_progress_sellers ||= Seller.where(id: SellerApplication.created.pluck(:seller_id))
  end

  def divisor
    @divisor ||= in_progress_sellers.count.to_f
  end

  def query_not_null_fields(*fields)
    in_progress_sellers.merge(not_null_scope(*fields))
  end

  def not_null_scope(*fields)
    parts = []

    fields.each {|field|
      parts << "#{field} IS NOT NULL"
    }

    Seller.where(parts.join(" AND "))
  end

  def document_kind_scope(kind)
    in_progress_sellers.
      includes(:documents).
      references(:documents).
      where('documents.kind' => kind)
  end

  def offering
    (in_progress_sellers.where("services != '{}' OR govdc = true").count.to_f / divisor * 100).round
  end

  def business_details
    (query_not_null_fields('name', 'abn').count.to_f / divisor * 100).round
  end

  def contact_details
    (
      query_not_null_fields('contact_name', 'contact_email', 'contact_phone',
        'representative_name', 'representative_email', 'representative_phone',
        'representative_position').count.to_f / divisor * 100
    ).round
  end

  def characteristics
    (
      query_not_null_fields('number_of_employees', 'corporate_structure').count.to_f / divisor * 100
    ).round
  end

  def addresses
    (
      in_progress_sellers.includes(:addresses).references(:addresses).merge(
        not_null_scope('seller_addresses.address', 'seller_addresses.suburb', 'seller_addresses.state', 'seller_addresses.postcode', 'seller_addresses.country')
      ).count / divisor * 100
    ).round
  end

  def disclosures
    disclosure_fields = [
      'receivership',
      'investigations',
      'legal_proceedings',
      'insurance_claims',
      'conflicts_of_interest',
      'other_circumstances',
    ]

    (query_not_null_fields(*disclosure_fields).count.to_f / divisor * 100).round
  end

  def financial_statement
    (
      document_kind_scope('financial_statement').merge(
        not_null_scope('documents.document', 'financial_statement_expiry')
      ).count.to_f / divisor * 100
    ).round
  end

  def product_liability
    (
      document_kind_scope('product_liability_certificate').merge(
        not_null_scope('documents.document', 'product_liability_certificate_expiry')
      ).count.to_f / divisor * 100
    ).round
  end

  def professional_indemnity
    (
      document_kind_scope('professional_indemnity_certificate').merge(
        not_null_scope('documents.document', 'professional_indemnity_certificate_expiry')
      ).count.to_f / divisor * 100
    ).round
  end

  def workers_compensation
    (
      document_kind_scope('workers_compensation_certificate').merge(
        Seller.where('(documents.document IS NOT NULL AND workers_compensation_certificate_expiry IS NOT NULL) OR workers_compensation_exempt = true')
      ).count.to_f / divisor * 100
    ).round
  end

  def products
    (
      in_progress_sellers.joins(:products).count.to_f / divisor * 100
    ).round
  end

  def terms_agreed
    (in_progress_sellers.where(agree: true).count.to_f / divisor * 100).round
  end

end
