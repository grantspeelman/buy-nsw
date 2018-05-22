class Sellers::SellerApplication::Products::Clone < Trailblazer::Operation
  step :model!
  step :build_new_product!
  step :copy_attributes!
  step :set_new_product_name!
  step :persist_new_product!
  step :copy_features_and_benefits!

  def model!(options, params:, **)
    return false unless options['current_user'].present?

    options[:application_model] = options['current_user'].seller_applications.find(params[:application_id])
    options[:seller_model] = options[:application_model].seller
    options[:product_model] = options[:seller_model].products.find(params[:id])
  end

  def build_new_product!(options, **)
    options[:new_product_model] = options[:seller_model].products.build
  end

  def copy_attributes!(options, **)
    attributes = options[:product_model].attributes.except(*excluded_attributes)
    options[:new_product_model].attributes = attributes
  end

  def set_new_product_name!(options, **)
    options[:new_product_model].name = "#{options[:product_model].name} copy"
  end

  def persist_new_product!(options, **)
    options[:new_product_model].save
  end

  def copy_features_and_benefits!(options, **)
    options[:product_model].features.each do |record|
      options[:new_product_model].features.create!(
        feature: record.feature,
      )
    end

    options[:product_model].benefits.each do |record|
      options[:new_product_model].benefits.create!(
        benefit: record.benefit,
      )
    end
  end

  def excluded_attributes
    [ 'id', 'created_at', 'updated_at', 'state' ]
  end
end
