FactoryBot.define do

  factory :document do
    association :documentable, factory: :seller
    kind 'financial_statement'
    document {
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
        'application/pdf'
      )
    }
    original_filename 'example.pdf'
    content_type 'application/pdf'

    trait :unscanned do
      scan_status 'unscanned'
    end

    trait :clean do
      scan_status 'clean'
    end

    trait :infected do
      scan_status 'infected'
    end

    factory :unscanned_document, traits: [:unscanned]
    factory :clean_document, traits: [:clean]
    factory :infected_document, traits: [:infected]
  end

end
