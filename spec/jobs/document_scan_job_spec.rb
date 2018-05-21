require 'rails_helper'
require 'carrierwave/storage/fog'

RSpec.describe DocumentScanJob, type: :job do

  let(:document) { create(:unscanned_document) }
  let(:file_path) { document.document.file.path }
  let(:example_file_body) {
    File.read(Rails.root.join('spec','fixtures','files','example.pdf'))
  }

  describe '#perform' do
    it 'sets the status of a clean file' do
      expect(Clamby).to receive(:safe?).with(file_path).and_return(true)
      described_class.perform_now(document)

      expect(document.reload.scan_status).to eq('clean')
    end

    it 'sets the status of an infected file' do
      expect(Clamby).to receive(:safe?).with(file_path).and_return(false)
      described_class.perform_now(document)

      expect(document.reload.scan_status).to eq('infected')
    end

    describe 'for a remote file (eg. S3)' do
      it 'downloads a remote file to the tmp folder' do
        tmp_file_path = Rails.root.join('tmp', 'scan', document.to_param, 'example.pdf').to_s
        url = "http://example.org/uploads/document/#{document.to_param}/example.pdf"

        expect(CarrierWave::Uploader::Base).to receive(:storage).and_return(CarrierWave::Storage::Fog)
        expect(document.document).to receive(:url).and_return(url)
        expect_any_instance_of(described_class).to receive(:open).with(url).and_return(example_file_body)
        expect(Clamby).to receive(:safe?).with(tmp_file_path).and_return(true)

        described_class.perform_now(document)

        expect(document.reload.scan_status).to eq('clean')
      end
    end
  end

end
