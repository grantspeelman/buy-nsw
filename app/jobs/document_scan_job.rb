class DocumentScanJob < ApplicationJob
  queue_as ENV.fetch('MAILER_QUEUE_NAME', :default)

  def perform(document)
    file = download_file(document)
    status = Clamby.safe?(file) ? 'clean' : 'infected'

    document.update_attribute(:scan_status, status)
  end

private
  def download_file(document)
    if remote_file?
      directory = Rails.root.join('tmp', 'scan', document.to_param)
      FileUtils.mkdir_p(directory)

      path = directory.join(document.original_filename)
      File.open(path, 'w+') {|f|
        f.write(open(document.document.url))
      }

      path.to_s
    else
      document.document.file.path
    end
  end

  def remote_file?
    CarrierWave::Uploader::Base.storage != CarrierWave::Storage::File
  end
end
