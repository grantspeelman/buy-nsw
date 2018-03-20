class Sellers::Applications::ProductsController < Sellers::BaseController
  layout '../sellers/applications/_layout'

  def index
    redirect_to action: :new unless products.any?
  end

  def new
    product = relation.create
    redirect_to sellers_application_product_path(application, product, new: true)
  end

  def show
    unless params.key?(:new)
      form.valid?
    end
  end

  def update
    valid = form.validate(params[:product])
    form.save

    if valid
      redirect_to action: :index
    else
      render action: :show
    end
  end

  def destroy
    product.destroy
    redirect_to action: :index
  end

private
  def application
    @application ||= current_user.seller_applications.created.find(params[:application_id])
  end
  helper_method :application

  def presenter
    @presenter ||= SellerApplicationPresenter.new(application,
                                                  current_step_slug: 'products')
  end
  helper_method :presenter

  def products
    @products ||= presenter.current_step_form.product_forms
  end
  helper_method :products

  def relation
    application.seller.products
  end

  def product
    @product ||= relation.find(params[:id])
  end

  def form
    @form ||= Sellers::Applications::Products::InfoForm.new(product)
  end
  helper_method :form

end
