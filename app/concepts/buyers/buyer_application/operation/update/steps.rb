class Buyers::BuyerApplication::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern

    def steps!(options, **)
      options['result.steps'] = step_contracts(options).map {|contract|
        Buyers::BuyerApplication::Step.new(
          application: options[:application_model],
          buyer: options[:buyer_model],
          contract_class: contract,
        )
      }
    end

    def step_contracts(options)
      steps = []

      steps << Buyers::BuyerApplication::Contract::BasicDetails

      if options[:application_model].requires_email_approval?
        steps << Buyers::BuyerApplication::Contract::EmailApproval
      end

      steps << Buyers::BuyerApplication::Contract::EmploymentStatus

      if options[:application_model].requires_manager_approval?
        steps << Buyers::BuyerApplication::Contract::ManagerApproval
      end

      steps << Buyers::BuyerApplication::Contract::Terms

      steps
    end
  end
end
