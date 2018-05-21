module Forms::DocumentHelper

  def file_attached?(document)
    document&.document&.url.present?
  end

  def file_clean?(document)
    document.scan_status == 'clean'
  end

end
