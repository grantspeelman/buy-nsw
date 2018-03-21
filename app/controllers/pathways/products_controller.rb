class Pathways::ProductsController < ApplicationController

  def show; end

private

  def product
    @product ||= Product.with_section(section).find(params[:id])
  end
  helper_method :product

  def section
    params[:section]
  end
  helper_method :section

end
