class Sellers::SellerApplication::Invitation::Accept < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :validate_confirmation_token!
    step Contract::Build( constant: Sellers::SellerApplication::Invitation::Contract::Accept )

    def validate_confirmation_token!(options, params:, **)
      options[:application_model] = SellerApplication.find(params[:application_id])

      unconfirmed_users = options[:application_model].seller.owners.unconfirmed
      options['model'] = unconfirmed_users.where(confirmation_token: params[:confirmation_token]).first

      options['model'].present?
    end
  end

  step Nested(Present)
  step Contract::Validate( key: :user )
  step :confirm_user!
  step Contract::Persist()

  def confirm_user!(options, model:, **)
    model.confirmed_at = Time.now
  end
end
