class Document < ApplicationRecord
  extend Enumerize

  belongs_to :documentable, polymorphic: true
  before_save :update_document_attributes
  validates :kind, :scan_status, presence: true
  mount_uploader :document, DocumentUploader
  
  enumerize :scan_status, in: ['unscanned', 'clean', 'infected']

  def update_document_attributes
    if document.present? && document_changed?
      self.original_filename = document.file.original_filename
      self.content_type = document.file.content_type
    end
  end

end
