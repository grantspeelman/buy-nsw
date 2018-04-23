module Sellers::Applications::RootHelper
  def progress_indicator_for(step)
    render partial: 'sellers/applications/shared/progress_indicator',
           locals: {
             step: step,
           }
  end
end
