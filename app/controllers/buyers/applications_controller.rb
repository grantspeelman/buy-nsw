class Buyers::ApplicationsController < Buyers::BaseController
  before_action :authenticate_user!, except: :manager_approve
  layout '../buyers/applications/_layout'

  def new
    run Buyers::BuyerApplication::Create do |result|
      return redirect_to buyers_application_path(result[:application_model].id)
    end

    redirect_to buyers_dashboard_path
  end

  def show
    @operation = Buyers::BuyerApplication::Update::Present.(params, edit_update_options)
  end

  def update
    params[:buyer_application] ||= {}

    @operation = Buyers::BuyerApplication::Update.(params, edit_update_options)

    if operation.success?
      if operation['result.submitted'] == true
        return redirect_to buyers_dashboard_path
      else
        flash.notice = I18n.t('buyers.applications.messages.changes_saved')
        return redirect_to buyers_application_step_path(operation['model.application'].id, form.next_step_slug)
      end
    end

    render :show
  end

  def manager_approve
    @operation = run Buyers::BuyerApplication::ManagerApprove

    flash.notice = (operation['result.approved'] == true) ?
      I18n.t('buyers.applications.messages.manager_approve_success') :
        I18n.t('buyers.applications.messages.manager_approve_failure')

    return redirect_to root_path
  end

private
  attr_reader :operation
  helper_method :operation

  # TODO: Make this work better
  #
  def application
    if ['new', 'create'].include?(action_name)
      operation['model.application']
    else
      @application ||= BuyerApplication.created.find_by_user_and_application(current_user, params[:id])
    end
  end
  helper_method :application

  def contract
    operation['contract.default']
  end
  helper_method :contract

  def _run_options(options)
    options.merge(
      'config.current_user' => current_user,
    )
  end

  def edit_update_options
    _run_options({}).merge(
      'config.form' => form,
      'model.application' => application,
    )
  end

  def form
    return @form if @form.is_a?(MultiStepForm)

    @form = MultiStepForm.new(
      contracts_block: contracts,
      contracts_args: [application],
      step: params[:step],
      i18n_key: 'buyers.applications',
    )
  end
  helper_method :form

  def contracts
    ->(application) {
      [].tap {|list|
        list << Buyers::BuyerApplication::Contract::BasicDetails
        if application.requires_email_approval?
          list << Buyers::BuyerApplication::Contract::EmailApproval
        end
        list << Buyers::BuyerApplication::Contract::EmploymentStatus
        if application.requires_manager_approval?
          list << Buyers::BuyerApplication::Contract::ManagerApproval
        end
        list << Buyers::BuyerApplication::Contract::Terms
      }
    }
  end

end
