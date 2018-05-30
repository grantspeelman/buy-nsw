module Sellers::Applications
  class ProductDashboardPresenter < DashboardPresenter
    def initialize(application, product, steps)
      @application = application
      @product = product
      @steps = steps
    end

    def task_list
      {
        section('details') => [
          step('type'),
          step('basics'),
          step('commercials'),
          step('terms'),
        ],
        section('support') => [
          step('onboarding_offboarding'),
          step('availability_support'),
          step('reporting_analytics'),
        ],
        section('data') => [
          step('identity_authentication'),
          step('environment'),
          step('locations'),
          step('user_data'),
          step('backup_recovery'),
        ],
        section('security') => [
          step('data_protection'),
          step('security_standards'),
          step('security_practices'),
          step('user_separation'),
          step('operational_security'),
        ],
      }
    end

    def step_complete?(step)
      progress_report.products_progress[product.id][step.key] == true
    end

  private
    attr_reader :steps, :application, :product

    def section(key)
      ProductSectionPresenter.new(key)
    end

    def progress_report
      @progress_report ||= SellerApplicationProgressReport.new(
        application: application,
        product_steps: steps,
      )
    end

  end
end
