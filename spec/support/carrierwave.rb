CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
  config.root = Rails.root.join('tmp','carrierwave')
end
