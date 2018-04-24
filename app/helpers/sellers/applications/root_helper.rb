module Sellers::Applications::RootHelper
  def progress_indicator_for(step)
    render partial: 'sellers/applications/shared/progress_indicator',
           locals: {
             step: step,
           }
  end

  def step_completed?(step)
    step['result.valid?'] == true
  end

  def step_started?(step)
    step['result.percent_complete'] > 0
  end

  def display_question_set(application, sets, key, options = {})
    render(
      partial: 'question_set',
      locals: options.merge(
        application: application,
        step: sets[key],
        key: key,
      )
    )
  end

  def step_button_label(step)
    case
    when step_completed?(step) then 'Edit'
    when step_started?(step) then 'Complete'
    else
      'Start'
    end
  end

  def disclosures_text_for(application)
    fields = [ :structural_changes, :investigations, :legal_proceedings, :insurance_claims, :conflicts_of_interest, :other_circumstances ]

    values = fields.select {|field| application.seller.send(field) == true }

    if values.any?
      pluralize(values.size, 'disclosure')
    else
      'None'
    end
  end

  def business_identifier_text_for(application)
    base = "activemodel.attributes.sellers.seller_application.profile.contract.characteristics"
    fields = [
      :start_up,
      :sme,
      :not_for_profit,
      :regional,
      :rural_remote,
      :travel,
      :disability,
      :australian_owned,
      :female_owned,
      :indigenous,
    ]

    selected = fields.select {|field| application.seller.send(field) == true }
    labels = selected.map {|field|
      I18n.t("#{base}.#{field}")
    }

    labels.sort.join('<br>').html_safe
  end

end
