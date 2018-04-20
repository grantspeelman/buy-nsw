class Buyers::BuyerApplication::Create < Trailblazer::Operation
  step :model!
  step :check_application_state!
  step :persist_with_relations!
  step :log_event!

  def model!(options, **)
    options[:buyer_model] = options['current_user'].buyer ||
                              Buyer.new(user: options['current_user'])

    options[:application_model] = options[:buyer_model].applications.first ||
                                    BuyerApplication.new(started_at: Time.now)
  end


  def check_application_state!(options, **)
    options[:application_model].created?
  end

  def persist_with_relations!(options, **)
    options[:buyer_model].save!
    options[:application_model].buyer = options[:buyer_model]
    options[:application_model].save!
  end

  def log_event!(options, **)
    Event.started_application!(
      options['current_user'], options[:application_model]
    )
  end
end
