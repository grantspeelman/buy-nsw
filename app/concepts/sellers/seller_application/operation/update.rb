class Sellers::SellerApplication::Update < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!
    step :contract!
    success :prevalidate_if_started!
    step :ensure_authorised_representative_for_legals!

    def model!(options, params:, **)
      options['model.seller'] = options['config.current_user'].seller
      options['model.application'] ||= options['model.seller'].applications.created.find(params[:id])

      options['model.application'].present?
    end

    def contract!(options, **)
      options['contract.default'] = options['config.contract_class'].new(
        application: options['model.application'],
        seller: options['model.seller'],
      )
    end

    def prevalidate_if_started!(options, params:, **)
      contract = options['contract.default']

      unless params.key?(:seller_application)
        contract.prepopulate!
        contract.validate(params.fetch(:seller_application, {})) if contract.started?
      end
    end

    def ensure_authorised_representative_for_legals!(options, **)
      representative_email = options['model.seller'].representative_email
      current_user_email = options['config.current_user'].email

      ! options['contract.default'].respond_to?(:agree) ||
        (representative_email.present? && (current_user_email == representative_email))
    end
  end

  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form.
  #
  success Contract::Validate( key: :seller_application )
  success :set_agreement_details!

  step Contract::Persist()

  success :expire_progress_cache!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step :prepopulate!
  step Contract::Validate()

  def expire_progress_cache!(options, **)
    cache_key = "sellers.applications.#{options['model.application'].id}.*"
    Rails.cache.delete_matched(cache_key)
  end

  def set_agreement_details!(options, **)
    contract = options['contract.default']
    seller = options['model.seller']

    if contract.changed.keys.include?('agree') && contract.agree == '1'
      seller.agreed_at = Time.now
    end
  end

  def prepopulate!(options, **)
    contract = options['contract.default']
    contract.prepopulate!
  end
end
