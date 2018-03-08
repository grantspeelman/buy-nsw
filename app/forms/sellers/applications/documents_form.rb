class Sellers::Applications::DocumentsForm < Sellers::Applications::BaseForm
  feature Reform::Form::ActiveModel::FormBuilderMethods
  feature Reform::Form::MultiParameterAttributes

  property :financial_statement,                on: :seller
  property :professional_indemnity_certificate, on: :seller
  property :workers_compensation_certificate,   on: :seller

  property :financial_statement_expiry,                on: :seller, multi_params: true
  property :professional_indemnity_certificate_expiry, on: :seller, multi_params: true
  property :workers_compensation_certificate_expiry,   on: :seller, multi_params: true

  validation :default do
    configure do
      config.messages = :i18n
      def file?(uploader_class)
        uploader_class.respond_to?(:original_filename) || uploader_class.file
      end

      def in_future?(date)
        date.present? && date > Date.today
      end
    end

    required(:seller).schema do
      required(:financial_statement).filled(:file?)
      required(:professional_indemnity_certificate).filled(:file?)
      required(:workers_compensation_certificate).filled(:file?)

      required(:financial_statement_expiry).filled(:date?, :in_future?)
      required(:professional_indemnity_certificate_expiry).filled(:date?, :in_future?)
      required(:workers_compensation_certificate_expiry).filled(:date?, :in_future?)
    end
  end
end
