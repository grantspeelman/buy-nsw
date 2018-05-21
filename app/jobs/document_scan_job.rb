class DocumentScanJob < ApplicationJob
  queue_as ENV.fetch('MAILER_QUEUE_NAME', :default)

  class ScanFailure < StandardError; end

  def perform(document)
    file = download_file(document)
    status = case Clamby.safe?(file)
              when true then 'clean'
              when false then 'infected'
              else
                raise ScanFailure
              end

    document.update_attribute(:scan_status, status)
  end

private
  def download_file(document)
    if remote_file?
      directory = Rails.root.join('tmp', 'scan', document.to_param)
      FileUtils.mkdir_p(directory)

      path = directory.join(document.original_filename)
      File.open(path, 'w+') {|f|
        f.write(open(document.document.url).read.force_encoding('UTF-8'))
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
