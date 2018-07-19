class Buyers::ProductOrder::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :ensure_active_buyer!, fail_fast: true
    step :model!
    step Contract::Build( constant: Buyers::ProductOrder::Contract::Create )

    def ensure_active_buyer!(options, **)
      (user = options['config.current_user']) && user.present? && user.is_active_buyer?
    end

    def model!(options, params:, **)
      options['model.buyer'] = options['config.current_user'].buyer
      options['model.product'] = Product.active.find(params[:id])
      options['model'] = options['model.buyer'].product_orders.build(
        product: options['model.product'],
      )
    end
  end
end
