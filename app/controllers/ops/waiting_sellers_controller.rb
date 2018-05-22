class Ops::WaitingSellersController < Ops::BaseController

  def upload
    @operation = run Ops::WaitingSeller::Upload

    if operation.success?
      if operation['result.persisted?'] == true
        flash.notice = 'Saved'
        redirect_to ops_waiting_sellers_path
      else
        render :upload
      end
    else
      flash.alert = "We couldn't parse any rows from your CSV"
      redirect_to ops_waiting_sellers_path
    end
  end

private
  def operation
    @operation
  end
  helper_method :operation

  def search
    @search ||= WaitingSellerSearch.new(
      selected_filters: params,
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

  def statistics
    @statistics ||= WaitingSeller.aasm.states.map {|state|
      [state.name, WaitingSeller.in_invitation_state(state.name).count]
    }
  end
  helper_method :statistics

end
