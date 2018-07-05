class Sellers::SellerApplication::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!
    step :check_application_state!

    def model!(options, **)
      options['model.seller'] = options['config.current_user'].seller || Seller.new

      options['model.application'] = options['model.seller'].versions.first ||
                                      SellerVersion.new(started_at: Time.now)
    end

    def check_application_state!(options, **)
      options['application_created'] = options['model.application'].persisted?
      options['application_submitted'] = (options['model.application'].state != 'created')

      options['application_created'] == false && options['application_submitted'] == false
    end
  end

  step Nested(Present)
  step :persist_with_relations!
  step :log_event!

  def persist_with_relations!(options, **)
    options['model.seller'].save!

    options['config.current_user'].seller = options['model.seller']
    options['model.application'].seller = options['model.seller']

    options['config.current_user'].save!
    options['model.application'].save!
  end

  def log_event!(options, **)
    Event::StartedApplication.create(
      user: options['config.current_user'],
      eventable: options['model.application']
    )
  end
end
