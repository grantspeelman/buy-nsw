class MultiStepForm
  module Navigation
    def first_step
      contracts.first
    end

    def last_step
      contracts.last
    end

    def first_step?
      current_step == first_step
    end

    def last_step?
      current_step == last_step
    end

    def next_step
      return last_step if last_step?

      index = contracts.index(current_step) + 1
      contracts[index]
    end

    def next_step_presenter
      @next_step_presenter ||= StepPresenter.new(next_step, i18n_key: i18n_key)
    end

    def next_step_slug
      next_step_presenter.slug
    end

    def previous_step
      return first_step if first_step?

      index = contracts.index(current_step) - 1
      contracts[index]
    end

    def previous_step_presenter
      @previous_step_presenter ||= StepPresenter.new(previous_step, i18n_key: i18n_key)
    end

    def previous_step_slug
      previous_step_presenter.slug
    end
  end
end
