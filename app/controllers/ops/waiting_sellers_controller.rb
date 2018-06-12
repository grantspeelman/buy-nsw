class Ops::WaitingSellersController < Ops::BaseController

  def edit
    @operation = run Ops::WaitingSeller::Update::Present
  end

  def update
    @operation = run Ops::WaitingSeller::Update do |result|
      flash.notice = 'Saved'
      return redirect_to edit_ops_waiting_seller_path(result['model'])
    end

    render :edit
  end

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

  def invite
    @operation = run Ops::WaitingSeller::Invite::Present

    if operation['result.error'] == :no_ids
      flash.alert = "You didn't select any sellers to invite"
      return redirect_to ops_waiting_sellers_path
    end
  end

  def do_invite
    @operation = run Ops::WaitingSeller::Invite do |result|
      flash.notice = 'Invitations sent'
      return redirect_to ops_waiting_sellers_path
    end

    render :invite
  end

private
  def operation
    @operation
  end
  helper_method :operation

  def search
    @search ||= Search::WaitingSeller.new(
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
