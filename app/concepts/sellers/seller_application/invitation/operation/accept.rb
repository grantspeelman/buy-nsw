class Sellers::SellerApplication::Invitation::Accept < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :validate_confirmation_token!
    step Contract::Build( constant: Sellers::SellerApplication::Invitation::Contract::Accept )

    def validate_confirmation_token!(options, params:, **)
      options[:application_model] = SellerVersion.created.find_by_id(params[:application_id])

      return false unless options[:application_model].present?

      unconfirmed_users = options[:application_model].seller.owners.unconfirmed
      options['model'] = unconfirmed_users.where(confirmation_token: params[:confirmation_token]).first

      options['model'].present?
    end
  end

  step Nested(Present)
  step Contract::Validate( key: :user )
  step :confirm_user!
  step Contract::Persist()
  failure :pass_devise_errors_to_contract!

  def pass_devise_errors_to_contract!(options, **)
    return unless options['model'].present?

    options['model'].errors.each do |key, error|
      options['contract.default'].errors.add(key, error)
    end
  end

  def confirm_user!(options, model:, **)
    model.confirmed_at = Time.now
  end
end
