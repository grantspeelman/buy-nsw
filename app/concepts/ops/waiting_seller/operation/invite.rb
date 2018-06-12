class Ops::WaitingSeller::Invite < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :check_params_present!, fail_fast: true
    step :models!
    step Contract::Build( constant: Ops::WaitingSeller::Contract::Invite )
    success Contract::Validate( key: :invite )
    step :validate_models!, fail_fast: true

    def check_params_present!(options, params:, **)
      if (ids = params.dig(:invite, :ids)) && ids.any?
        true
      else
        options['result.error'] = :no_ids
        false
      end
    end

    def models!(options, params:, **)
      options['models'] = params[:invite][:ids].map {|id|
        WaitingSeller.created.find(id)
      }
    end

    def validate_models!(options, **)
      contract = Ops::WaitingSeller::Contract::Update

      options['result.invalid_model_ids'] = options['models'].reject {|model|
        contract.new(model).valid?
      }.map(&:id)

      options['result.invalid_model_ids'].empty?
    end
  end

  step Nested(Present)
  step Contract::Validate( key: :invite )
  step :update_seller_attributes!
  step :persist_models!
  step :send_invitation_email!

  def update_seller_attributes!(options, **)
    options['models'].each do |model|
      model.invitation_token = SecureRandom.hex(24)
      model.invited_at = Time.now
      model.mark_as_invited
    end
  end

  def persist_models!(options, **)
    persisted = options['models'].map(&:save)

    # Return false if any objects failed to save
    #
    persisted.reject {|outcome| outcome == true }.empty?
  end

  def send_invitation_email!(options, **)
    options['models'].each do |model|
      mailer = WaitingSellerMailer.with(waiting_seller: model)
      mailer.invitation_email.deliver_later
    end
  end
end
