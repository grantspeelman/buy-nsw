class Sellers::SellerApplication::Products::Update < Trailblazer::Operation
  class Present < Sellers::SellerApplication::Update::Present
    def model!(options, params:, **)
      options['model.seller'] = options['config.current_user'].seller
      options['model.application'] ||= options['model.seller'].applications.created.find(params[:application_id])
      options['model.product'] = options['model.seller'].products.find(params[:id])

      options['model.product'].present?
    end

    def contract!(options, **)
      options['contract.default'] = options['config.contract_class'].new(
        application: options['model.application'],
        seller: options['model.seller'],
        product: options['model.product'],
      )
    end
  end

  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form.
  #
  success Contract::Validate( key: :seller_application )
  step Contract::Persist()

  success :expire_progress_cache!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step :prepopulate!
  step Contract::Validate()

  def expire_progress_cache!(options, **)
    cache_key = "sellers.products.#{options['model.product'].id}.*"
    Rails.cache.delete_matched(cache_key)
  end

  def prepopulate!(options, **)
    contract = options['contract.default']
    contract.prepopulate!
  end
end
