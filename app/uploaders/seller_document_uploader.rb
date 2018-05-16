class SellerDocumentUploader < CarrierWave::Uploader::Base
  # This number should be the same as the guidance in the content:
  # app/views/sellers/applications/_documents_form.html.erb
  def size_range
    1..5.megabytes
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg pdf png)
  end

  def content_type_whitelist
    ['image/jpeg', 'image/png', 'application/pdf']
  end
end
