class Sellers::ApplicationsController < Sellers::BaseController
  before_action :authenticate_user!

  rescue_from SellerApplicationStepPresenter::NotFound, with: :error_404
  layout '../sellers/applications/_layout'

  def new
    if existing_application.present?
      redirect_to sellers_application_path(existing_application)
    else
      seller = Seller.create!(owner: current_user)
      application = seller.applications.create!(owner: current_user)

      redirect_to sellers_application_path(application)
    end
  end

  def show
    if params[:step].present?
      form.prepopulate!

      if presenter.current_step.started?
        form.valid?
      end
    else
      redirect_to presenter.first_step_path
    end
  end

  def update
    if params.key?(:application)
      if form.validate(params[:application])
        form.save

        if presenter.last_step? && presenter.valid?
          application.submit!
          flash.notice = 'Your seller application has been submitted.'
          redirect_to root_path
        else
          redirect_to presenter.next_step_path
        end
      else
        form.save
        form.prepopulate!

        render action: :show
      end
    else
      redirect_to presenter.next_step_path
    end
  end

private
  def application
    @application ||= current_user.seller_applications.created.find(params[:id])
  end
  helper_method :application

  def presenter
    @presenter ||= SellerApplicationPresenter.new(application,
                                                  current_step_slug: params[:step])
  end
  helper_method :presenter

  def form
    presenter.current_step_form
  end

  def existing_application
    @existing_application ||= current_user.seller_applications.created.first
  end

end
