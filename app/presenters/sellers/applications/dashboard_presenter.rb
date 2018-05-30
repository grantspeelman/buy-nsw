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
      tuples = all_tasks.map {|section, steps|
        [section, steps.compact] if steps.compact.any?
      }.compact

      Hash[tuples]
    end

    def all_tasks
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
          product_step,
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

    def ineligible?
      step('services').started?(application) &&
        (application.seller.govdc == false && !provides_cloud_services?)
    end

  private
    attr_reader :steps, :application

    def step(key)
      steps.find {|s| s.key == key }
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

    def provides_cloud_services?
      application.seller.services.include?('cloud-services')
    end

    def product_step
      if provides_cloud_services?
        InlineStep.new(:products, :sellers_application_products_path)
      end
    end

  end
end
