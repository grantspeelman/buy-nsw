module Sellers::Applications
  class DashboardPresenter
    class InlineStep < Struct.new(:key, :route_helper)
      def name(type: :short)
        I18n.t("sellers.applications.steps.#{key}.#{type}")
      end

      def path(application:, product: nil)
        Rails.application.routes.url_helpers.send(self.route_helper, application)
      end
    end

    def initialize(application, steps)
      @application = application
      @steps = steps
    end

    def task_list
      {
        section('check') => [
          step('services'),
        ],
        section('business') => [
          step('business_details'),
          step('contacts'),
          step('addresses'),
          step('characteristics'),
          step('disclosures'),
          step('profile_basics'),
          step('recognition'),
        ],
        section('documents') => [
          step('financial_statement'),
          step('product_liability'),
          step('professional_indemnity'),
          step('workers_compensation'),
        ],
        section('offering') => [
          InlineStep.new(:products, :sellers_application_products_path),
        ],
        section('apply') => [
          step('declaration'),
          InlineStep.new(:submit, :submit_sellers_application_path),
        ]
      }
    end

    def step_complete?(step)
      progress_report.base_progress[step.key] == true
    end

  private
    attr_reader :steps, :application

    def step(key)
      steps.find {|s| s.key == key } || raise('Step not found')
    end

    def section(key)
      SectionPresenter.new(key)
    end

    def progress_report
      @progress_report ||= SellerApplicationProgressReport.new(
        application: application,
        base_steps: steps,
      )
    end

  end
end
