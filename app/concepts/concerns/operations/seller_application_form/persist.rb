module Concerns::Operations::SellerApplicationForm::Persist
  extend ActiveSupport::Concern

  included do
    # NOTE: We use the Validate method here to assign values, but we don't care
    # if they are invalid as we want the user to be able to return later to edit
    # the form. The full validation check is performed in the
    # `submit_if_valid_and_last_step!` step.
    #
    success Trailblazer::Operation::Contract::Validate( key: :seller_application )

    step Trailblazer::Operation::Contract::Persist()

    success :steps!
    success :next_step!

    success :complete_if_last_step!
    success :expire_progress_cache!

    # NOTE: Invoking this again at the end of the flow means that we can add
    # validation errors and show the form again when the fields are invalid.
    #
    step :prepopulate!
    step Trailblazer::Operation::Contract::Validate()
  end

  
end
