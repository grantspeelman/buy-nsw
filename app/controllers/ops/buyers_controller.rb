class Ops::BuyersController < Ops::BaseController

  layout ->{
    action_name == 'index' ? 'ops' : '../ops/buyers/_layout'
  }

  def show
  end

  def deactivate
    run Ops::Buyer::Deactivate do |result|
      flash.notice = I18n.t('ops.buyers.messages.deactivate_success')
      return redirect_to ops_buyer_path(buyer)
    end

    render :show
  end

private
  def search
    @search ||= BuyerSearch.new(
      selected_filters: params,
    )
  end
  helper_method :search

  def buyer
    @buyer ||= Buyer.find(params[:id])
  end
  helper_method :buyer
end
