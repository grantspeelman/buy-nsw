module Concerns::Documentable
  extend ActiveSupport::Concern

  class_methods do
    def has_documents(*fields)
      fields.map(&:to_s).each do |field|
        after_initialize do
          @documents = {}
        end

        after_save do
          @documents.each {|key, doc|
            doc.save! if doc.document_changed? && !doc.destroyed?
          }
        end

        define_method(field) do
          @documents[field] ||= documents.find_or_initialize_by(kind: field)
        end

        define_method("#{field}_file") do
          self.public_send(field).document
        end

        define_method("#{field}_file=") do |file|
          # NOTE: Check that this is actually an uploaded file
          # (eg. ActionDispatch::Http::UploadedFile) and not just an instance
          # of the Carrierwave uploader object being re-assigned.
          #
          if file.respond_to?(:tempfile)
            self.public_send("#{field}").document = file
          end
        end

        define_method("remove_#{field}") do
          false
        end

        define_method("remove_#{field}=") do |value|
          self.public_send("#{field}").destroy unless (value.blank? || value == '0')
        end
      end
    end
  end

  included do
    private_class_method :has_documents

    has_many :documents, as: :documentable, autosave: true, dependent: :destroy
  end

end
