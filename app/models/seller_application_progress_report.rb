class SellerApplicationProgressReport
  def initialize(application:, base_steps: nil, product_steps: nil, validate_optional_steps: false)
    @application = application
    @base_steps = base_steps
    @product_steps = product_steps
    @validate_optional_steps = validate_optional_steps

    @cache_length = 1.second
  end

  def all_steps_valid?
    base_valid = base_progress.reject {|_, valid|
      valid == true
    }.empty?

    products_valid = products_progress.reject {|id, product|
      product['_overall'] == true
    }.empty?

    base_valid && products_valid
  end

  def base_progress
    @base_progress ||= build_base_progress
  end

  def products_progress
    @products_progress ||= build_products_progress
  end

private
  attr_reader :application, :cache_length, :base_steps, :product_steps,
    :validate_optional_steps

  def build_base_progress
    cache_key = "sellers.applications.#{application.id}.#{validate_optional_steps.to_s}"

    Rails.cache.fetch(cache_key, expires_in: cache_length) do
      build_step_progress(base_steps, application)
    end
  end

  def build_products_progress
    tuples = application.seller.products.map do |product|
      cache_key = "sellers.products.#{product.id}.#{validate_optional_steps.to_s}"

      progress = Rails.cache.fetch(cache_key, expires_in: cache_length) do
        build_step_progress(product_steps, application, product)
      end
      progress['_overall'] = progress.reject {|_,v| v == true }.empty?

      [product.id, progress]
    end

    progress = Hash[tuples]
  end

  def build_step_progress(steps, application, product = nil)
    {}.tap do |output|
      steps.each do |step|
        output[step.key] = product.present? ?
          step.complete?(application, product, validate_optional_steps: validate_optional_steps) :
          step.complete?(application, validate_optional_steps: validate_optional_steps)
      end
    end
  end
end
