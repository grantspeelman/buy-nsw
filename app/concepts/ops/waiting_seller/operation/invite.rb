class Ops::WaitingSeller::Invite < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :models!
    step Contract::Build( constant: Ops::WaitingSeller::Contract::Invite )
    success Contract::Validate( key: :invite )

    def models!(options, params:, **)
      options['models'] = params[:invite][:ids].map {|id|
        WaitingSeller.created.find(id)
      }
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
