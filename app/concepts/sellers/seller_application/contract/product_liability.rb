module Sellers::SellerApplication::Contract
  class ProductLiability < Base
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :product_liability_certificate_file,   on: :seller
    property :product_liability_certificate_expiry, on: :seller, multi_params: true
    property :remove_product_liability_certificate, on: :seller

    module Types
      include Dry::Types.module

      File = Types::Any.constructor do |file|
        # A file which has already been uploaded to the resource and is a
        # CarrierWave Uploader object.
        #
        # file.filename returns the path.
        #
        if file.respond_to?(:file) && file.file.present?
          file.file.filename

        # A file which is being uploaded in this request, and is an instance of
        # ActionDispatch::Http::UploadedFile.
        #
        # file.original_filename returns the path here.
        #
        elsif file.respond_to?(:original_filename) && file.original_filename.present?
          file.original_filename
        end
      end
    end

    validation :default, inherit: true do
      configure do
        config.type_specs = true

        def file_uploaded?(document)
          document.present?
        end
      end

      required(:seller).schema do
        required(:product_liability_certificate_file, Types::File).maybe(:file_uploaded?)
        required(:product_liability_certificate_expiry, Types::Date).maybe(:date?, :in_future?)

        rule(product_liability_certificate_expiry: [:product_liability_certificate_file, :product_liability_certificate_expiry]) do |file, expiry|
          file.filled?.then(expiry.filled?)
        end
      end
    end

    def started?
      super do |key, value|
        next if key == 'product_liability_certificate'
        value.present?
      end
    end
  end
end
