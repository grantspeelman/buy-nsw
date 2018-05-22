require 'csv'

class Ops::WaitingSeller::Upload < Trailblazer::Operation

  step :validate_file!
  step :parse_from_csv!
  step :build_seller_objects!
  step :validate_rows!
  step :persist_rows!

  def validate_file!(options, params:, **)
    params[:file_contents].present? || params[:file].present?
  end

  def parse_from_csv!(options, params:, **)
    options['result.file_contents'] = params.key?(:file_contents) ?
      Base64.decode64(params[:file_contents]) : File.read(params[:file].path)

    begin
      options['result.file'] = CSV.parse(options['result.file_contents'], headers: true)
    rescue CSV::MalformedCSVError
      return false
    end
  end

  def build_seller_objects!(options, **)
    options['result.waiting_sellers'] = options['result.file'].map {|row|
      WaitingSeller.new(row.to_hash.slice(*fields))
    }
  end

  def validate_rows!(options, **)
    options['result.waiting_sellers'].any?
  end

  def persist_rows!(options, params:, **)
    return true if params[:complete].blank?

    options['result.waiting_sellers'].map(&:save!)
    options['result.persisted?'] = true
  end

  def fields
    ['name', 'abn', 'address', 'suburb', 'postcode', 'state', 'country', 'contact_name', 'contact_email', 'contact_position', 'website_url']
  end

end
