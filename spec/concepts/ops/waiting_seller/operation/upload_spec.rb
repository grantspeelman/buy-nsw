require 'rails_helper'

RSpec.describe Ops::WaitingSeller::Upload do

  let(:csv_file) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec','fixtures','files','waiting_seller_list.csv')
    )
  }

  subject { Ops::WaitingSeller::Upload }

  describe '#parse_from_csv!' do

    describe 'given a CSV file' do
      it 'parses WaitingSeller objects' do
        result = subject.({ file: csv_file })

        expect(result).to be_success
        expect(result['result.waiting_sellers'].count).to eq(2)
        expect(result['result.waiting_sellers'].first).to be_a(WaitingSeller)
      end

      it 'correctly assigns attributes' do
        result = subject.({ file: csv_file })
        seller = result['result.waiting_sellers'].first

        expect(seller.name).to eq('Smith-Churchill Enterprises')
        expect(seller.abn).to eq('10123456789')
        expect(seller.address).to eq('123 Test Street')
        expect(seller.suburb).to eq('Sydney')
        expect(seller.state).to eq('NSW')
        expect(seller.country).to eq('Australia')
        expect(seller.contact_name).to eq('Winston Smith-Churchill')
        expect(seller.contact_email).to eq('test-1@test.buy.nsw.gov.au')
        expect(seller.contact_position).to eq('Test')
        expect(seller.website_url).to eq('http://example.org')
      end
    end

    describe 'given a base64-encoded string' do
      let(:string) { Base64.encode64(File.read(csv_file.path)) }

      it 'parses WaitingSeller objects' do
        result = subject.({ file_contents: string })

        expect(result).to be_success
        expect(result['result.waiting_sellers'].count).to eq(2)
        expect(result['result.waiting_sellers'].first).to be_a(WaitingSeller)
      end

      it 'correctly assigns attributes' do
        result = subject.({ file_contents: string })
        seller = result['result.waiting_sellers'].first

        expect(seller.name).to eq('Smith-Churchill Enterprises')
        expect(seller.abn).to eq('10123456789')
        expect(seller.address).to eq('123 Test Street')
        expect(seller.suburb).to eq('Sydney')
        expect(seller.state).to eq('NSW')
        expect(seller.country).to eq('Australia')
        expect(seller.contact_name).to eq('Winston Smith-Churchill')
        expect(seller.contact_email).to eq('test-1@test.buy.nsw.gov.au')
        expect(seller.contact_position).to eq('Test')
        expect(seller.website_url).to eq('http://example.org')
      end
    end

    it 'fails given a malformed CSV' do
      string = Base64.encode64('Foo",""",bar";')
      result = subject.({ file_contents: string })

      expect(result).to be_failure
    end
  end

  describe '#validate_file!' do
    it 'fails when the file and file_contents params are empty' do
      result = subject.({ file: nil, file_contents: nil })

      expect(result).to be_failure
    end
  end

  describe "#validate_rows!" do
    it 'fails when there are no WaitingSeller objects' do
      # Just use the header row
      contents = Base64.encode64(
        File.read(csv_file.path).split("\n").first
      )
      result = subject.({ file_contents: contents })

      expect(result).to be_failure
    end
  end

  describe '#persist_rows!' do
    it 'does not persist rows when the "complete" parameter is blank' do
      result = subject.({ file: csv_file, complete: nil })

      expect(result['result.persisted?']).to be_nil
      expect(WaitingSeller.count).to eq(0)
    end

    it 'persists rows when the "complete" parameter is true' do
      result = subject.({ file: csv_file, complete: true })

      expect(result).to be_success
      expect(result['result.persisted?']).to be_truthy
      expect(WaitingSeller.count).to eq(2)
    end
  end

end
