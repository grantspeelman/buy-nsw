class Sellers::Applications::ProductsForm < Sellers::Applications::BaseForm

  def valid?
    product_forms.any? && product_forms.reject(&:valid?).blank?
  end

  def started?
    product_forms.any?
  end

  def product_forms
    seller.products.map {|product|
      Sellers::Applications::Products::InfoForm.new(product)
    }
  end

end
