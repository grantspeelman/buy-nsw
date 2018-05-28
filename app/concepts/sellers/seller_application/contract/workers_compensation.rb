module Sellers::SellerApplication::Contract
  class WorkersCompensation < Base
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :workers_compensation_certificate_file,   on: :seller
    property :workers_compensation_certificate_expiry, on: :seller, multi_params: true
    property :workers_compensation_exempt,             on: :seller

    # NOTE: Trying to implement conditional validation on this model has been
    # painstaking, but the following does work.
    #
    # Because the `workers_compensation_certificate` field is actually an
    # instance of a CarrierWave Uploader on the model, it never returns `nil`.
    #
    # Therefore, when we try to create a validation rule which says "only
    # validate the file when the checkbox is false", the presence of the field
    # (as an object) causes the validation library to validate it anyway.
    #
    # The fix has been to coerce the file input into a string using Dry's Types
    # functionality. This means we can search through the Uploader object to
    # check if the file actually exists, and use that value instead.
    #
    # Of course, this is never simple, so we have to also handle the case that
    # the file is an instance of ActionDispatch::Http::UploadedFile, which it is
    # for a request where a user is actually uploading a new file.
    #

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

    # NOTE: This is a fix for when a user has unchecked the 'exempt' box but
    # the rest of the form is empty. This should be the 'unstarted' state however
    # the code (in app/concepts/concerns/contracts/status.rb) does a check for
    # "value == false" to support cases like the disclosures form, where every
    # field could be false (when a user selects 'no' in each radio button).
    #
    # We will need to find a more elegant solution to this problem over time. In
    # the short term, we can override the method with a block which removes the
    # check for the `false` field in this case.
    #
    # There are test cases for this behaviour in the specs:
    #   - spec/concepts/sellers/seller_application/contract/disclosures_spec.rb
    #   - spec/concepts/sellers/seller_application/contract/workers_compensation_spec.rb
    #
    def started?
      super do |key, value|
        value.present?
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
        # NOTE: When you enable types in Dry-validation, you are then required
        # to specify the type of all attributes in the schema.
        #
        # If you miss an attribute, it will quietly fail and ignore it.
        #
        required(:workers_compensation_exempt, Types::Bool).filled
        required(:workers_compensation_certificate_file, Types::File).maybe(:file_uploaded?)
        required(:workers_compensation_certificate_expiry, Types::Date).maybe(:date?, :in_future?)

        rule(workers_compensation_certificate_file: [:workers_compensation_exempt, :workers_compensation_certificate_file]) do |exempt, document|
          exempt.false?.then(document.filled?)
        end
        rule(workers_compensation_certificate_expiry: [:workers_compensation_exempt, :workers_compensation_certificate_expiry]) do |exempt, expiry|
          exempt.false?.then(expiry.filled?)
        end
      end
    end
  end
end
