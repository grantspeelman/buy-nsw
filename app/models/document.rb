class Document < ApplicationRecord
  extend Enumerize

  belongs_to :documentable, polymorphic: true
  validates :kind, :scan_status, presence: true
  mount_uploader :document, DocumentUploader

  before_save :update_document_attributes
  after_save :scan_file

  enumerize :scan_status, in: ['unscanned', 'clean', 'infected']

  def url
    document.url
  end

  def mime_type
    MIME::Types[content_type].first
  end

  def update_document_attributes
    if document.present? && document_changed?
      self.scan_status = 'unscanned'
      self.original_filename = document.file.original_filename
      self.content_type = document.file.content_type
    end
  end

  def scan_file
    DocumentScanJob.perform_later(self) if saved_change_to_attribute?(:document)
  end

end
