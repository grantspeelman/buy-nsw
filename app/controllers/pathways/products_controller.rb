class Pathways::ProductsController < ApplicationController

  def show; end

private

  def product
    @product ||= ProductDecorator.new(
      Product.active.with_section(section).find(params[:id]),
      view_context,
    )
  end
  helper_method :product

  def section
    params[:section]
  end
  helper_method :section

end
