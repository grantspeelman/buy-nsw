class SellerApplicationProgressReport
  def initialize(application:, question_sets:, product_question_set:)
    @application = application
    @question_sets = question_sets
    @product_question_set = product_question_set

    @config = {}
    @steps = {}
    @product_config = {}
    @product_steps = {}

    @cache_length = 12.hours
  end

  def all_question_sets_valid?
    question_set_progress.reject {|key, question_set|
      question_set[:valid] == true
    }.empty?
  end

  def question_set_progress
    @question_set_progress ||= build_progress
  end

private
  attr_reader :application, :cache_length, :product_question_set, :question_sets

  def build_progress
    build_question_set_progress.merge(
      build_product_question_set_progress
    )
  end

  def build_question_set_progress
    {}.tap do |output|
      question_sets.each do |question_set|
        config = build_configuration(question_set)
        key = config.get(:i18n_key)
        cache_key = "#{key}-#{application.id}"

        output[key] = Rails.cache.fetch(cache_key, expires_in: cache_length) do
          steps = build_steps(question_set)
          {
            percent_complete: percent_complete(steps),
            valid: all_steps_valid?(steps),
          }
        end
      end
    end
  end

  def build_product_question_set_progress
    {}.tap do |output|
      products.each do |product|
        key = "sellers.applications.products.#{product.id}"

        output[key] = Rails.cache.fetch(key, expires_in: cache_length) do
          steps = build_product_steps(product)
          {
            percent_complete: percent_complete(steps),
            valid: all_steps_valid?(steps),
          }
        end
      end
    end
  end

  def percent_complete(steps)
    required_fields_to_complete = steps.map(&:required_fields_to_complete).inject(&:+).to_f
    required_fields_completed = steps.map(&:required_fields_completed).inject(&:+).to_f

    return 100 if required_fields_to_complete == 0

    (required_fields_completed / required_fields_to_complete * 100).round
  end

  def all_steps_valid?(steps)
    steps.reject(&:valid?).empty?
  end

  def build_configuration(question_set)
    @config[question_set] ||= Concerns::Operations::MultiStepForm::Configuration.new(
      question_set.step_configuration_block, models
    )
  end

  def build_product_configuration(product)
    @product_config[product.id] ||= Concerns::Operations::MultiStepForm::Configuration.new(
      product_question_set.step_configuration_block, models.merge(product_model: product)
    )
  end

  def build_steps(question_set)
    @steps[question_set] ||= Concerns::Operations::MultiStepForm::Builder.new(
      question_set.step_contract_block,
      operation_result: models,
      config: build_configuration(question_set),
    ).steps
  end

  def build_product_steps(product)
    @product_steps[product.id] ||= Concerns::Operations::MultiStepForm::Builder.new(
      product_question_set.step_contract_block,
      operation_result: models.merge(product_model: product),
      config: build_product_configuration(product),
    ).steps
  end

  def models
    {
      application_model: application,
      seller_model: application.seller,
    }
  end

  def products
    application.seller.products
  end
end
