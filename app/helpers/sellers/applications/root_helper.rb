module Sellers::Applications::RootHelper
  def progress_indicator_for(question_set)
    render partial: 'sellers/applications/shared/progress_indicator',
           locals: {
             question_set: question_set,
           }
  end

  def question_set_completed?(question_set)
    question_set[:valid] == true
  end

  def question_set_started?(question_set)
    question_set[:percent_complete] > 0
  end

  def display_question_set(application, progress_report, key, options = {})
    render(
      partial: 'question_set',
      locals: options.merge(
        application: application,
        question_set: progress_report.question_set_progress["sellers.applications.#{key}"],
        key: key,
      )
    )
  end

  def question_step_button_label(question_set)
    case
    when question_set_completed?(question_set) then 'Edit'
    when question_set_started?(question_set) then 'Complete'
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
