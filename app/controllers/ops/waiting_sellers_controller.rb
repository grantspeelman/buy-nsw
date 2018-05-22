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

end
