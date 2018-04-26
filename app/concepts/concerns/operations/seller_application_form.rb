module Concerns::Operations::SellerApplicationForm
  extend ActiveSupport::Concern

  included do
    include Concerns::Operations::MultiStepForm

    step :model!
    step :steps!
    step Trailblazer::Operation::Contract::Build( builder: :build_contract_from_step! )

    success :prevalidate_if_started!
  end

  def model!(options, params:, **)
    options[:application_model] ||= SellerApplication.created.find_by_user_and_application(options['current_user'], params[:id])
    options[:seller_model] = options[:application_model].seller

    options[:application_model].present?
  end
end
