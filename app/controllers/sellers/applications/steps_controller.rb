class Sellers::Applications::StepsController < Sellers::Applications::BaseController
  layout '../sellers/applications/shared/_layout'

  def show
    @operation = run Sellers::SellerVersion::Update::Present
  end

  def update
    params[:seller_application] ||= {}

    @operation = run Sellers::SellerVersion::Update do |result|
      flash.notice = I18n.t('sellers.applications.messages.changes_saved')
      return redirect_to sellers_application_path(result['model.seller_version'])
    end

    render :show
  end

  def self.contracts(seller_version)
    base_contracts = [
      Sellers::SellerVersion::Contract::BusinessDetails,
      Sellers::SellerVersion::Contract::Addresses,
      Sellers::SellerVersion::Contract::Characteristics,
      Sellers::SellerVersion::Contract::Contacts,
      Sellers::SellerVersion::Contract::Disclosures,
      Sellers::SellerVersion::Contract::FinancialStatement,
      Sellers::SellerVersion::Contract::ProductLiability,
      Sellers::SellerVersion::Contract::ProfessionalIndemnity,
      Sellers::SellerVersion::Contract::ProfileBasics,
      Sellers::SellerVersion::Contract::Recognition,
      Sellers::SellerVersion::Contract::Services,
      Sellers::SellerVersion::Contract::WorkersCompensation,
    ]
    base_contracts.tap {|contracts|
      if seller_version.services.include?('cloud-services')
        contracts << Sellers::SellerVersion::Contract::Declaration
      end
    }
  end

  def self.steps(seller_version)
    contracts(seller_version).map {|contract|
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
    self.class.steps(seller_version).find {|step| step.slug == params[:step] } || raise(NotFound)
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

  def form
    operation["contract.default"]
  end
  helper_method :form

  def seller_version
    operation.present? ? operation['model.seller_version'] : super
  end
end
