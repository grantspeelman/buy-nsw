class Sellers::Applications::RootController < Sellers::Applications::BaseController
  def new
    if existing_application.present?
      redirect_to sellers_application_path(existing_application)
    elsif current_user.seller.present?
      redirect_to sellers_dashboard_path
    else
      seller = Seller.create!(owner: current_user)
      application = seller.applications.create!
      Event::Event.started_application!(current_user, application)

      redirect_to sellers_application_path(application)
    end
  end

  def show
    unless steps[:tailor]['result.valid?'] == true
      return redirect_to(tailor_sellers_application_path(existing_application))
    end

    render :show
  end

  def submit
    run Sellers::SellerApplication::Submit do |result|
      return redirect_to sellers_dashboard_path
    end

    return redirect_to sellers_application_path(application)
  end

private
  def existing_application
    @existing_application ||= current_user.seller_applications.created.first
  end

  def application
    @application ||= current_user.seller_applications.created.find(params[:id])
  end

  def steps
    {
      tailor: run(Sellers::SellerApplication::Tailor::Update::Present),
      contacts: run(Sellers::SellerApplication::Contacts::Update::Present),
      documents: run(Sellers::SellerApplication::Documents::Update::Present),
      profile: run(Sellers::SellerApplication::Profile::Update::Present),
      legals: run(Sellers::SellerApplication::Legals::Update::Present),
    }
  end
  helper_method :steps

  def can_submit_application?
    steps.reject {|key, step|
      step['result.valid?']
    }.empty?
  end
  helper_method :can_submit_application?

  def submit_form
    @operation ||= run(Sellers::SellerApplication::Submit::Present)
  end
  helper_method :submit_form

  def _run_options(options)
    super.merge( :application_model => application )
  end
end
