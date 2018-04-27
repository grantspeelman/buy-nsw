class Sellers::SellerApplication::Create < Trailblazer::Operation
  step :model!
  step :check_application_state!
  step :persist_with_relations!
  step :log_event!

  def model!(options, **)
    options[:seller_model] = options['current_user'].seller || Seller.new

    options[:application_model] = options[:seller_model].applications.first ||
                                    SellerApplication.new(started_at: Time.now)
  end

  def check_application_state!(options, **)
    options[:application_model].created?
  end

  def persist_with_relations!(options, **)
    options[:seller_model].save!

    options['current_user'].seller = options[:seller_model]
    options[:application_model].seller = options[:seller_model]

    options['current_user'].save!
    options[:application_model].save!
  end

  def log_event!(options, **)
    Event::StartedApplication.create(
      user: options['current_user'],
      eventable: options[:application_model]
    )
  end
end
