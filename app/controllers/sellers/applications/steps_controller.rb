class Sellers::Applications::StepsController < Sellers::Applications::BaseController
  layout '../sellers/applications/shared/_layout'

  def show
    @operation = run Sellers::SellerApplication::Update::Present
  end

  def update
    params[:seller_application] ||= {}

    @operation = run Sellers::SellerApplication::Update do |result|
      flash.notice = I18n.t('sellers.applications.messages.changes_saved')
      return redirect_to sellers_application_path(result['model.application'])
    end

    flash.now.alert = I18n.t('sellers.applications.messages.changes_saved_with_errors')
    render :show
  end

  def self.contracts(application)
    base_contracts = [
      Sellers::SellerApplication::Contract::BusinessDetails,
      Sellers::SellerApplication::Contract::Addresses,
      Sellers::SellerApplication::Contract::Characteristics,
      Sellers::SellerApplication::Contract::Contacts,
      Sellers::SellerApplication::Contract::Disclosures,
      Sellers::SellerApplication::Contract::FinancialStatement,
      Sellers::SellerApplication::Contract::ProductLiability,
      Sellers::SellerApplication::Contract::ProfessionalIndemnity,
      Sellers::SellerApplication::Contract::ProfileBasics,
      Sellers::SellerApplication::Contract::Recognition,
      Sellers::SellerApplication::Contract::Services,
      Sellers::SellerApplication::Contract::WorkersCompensation,
    ]
    base_contracts.tap {|contracts|
      if application.seller.services.include?('cloud-services')
        contracts << Sellers::SellerApplication::Contract::Declaration
      end
    }
  end

  def self.steps(application)
    contracts(application).map {|contract|
      Sellers::Applications::StepPresenter.new(contract)
    }
  end

private
  def _run_options(options)
    options.merge(
      'config.current_user' => current_user,
      'config.contract_class' => contract_class,
    )
  end

  def step
    self.class.steps(application).find {|step| step.slug == params[:step] } || raise(NotFound)
  end
  helper_method :step

  def contract_class
    step.contract_class
  end

  def operation
    @operation
  end
  helper_method :operation

  def seller
    operation['model.seller']
  end
  helper_method :seller

  def seller
    operation['model.application']
  end
  helper_method :application

  def form
    operation["contract.default"]
  end
  helper_method :form

end
