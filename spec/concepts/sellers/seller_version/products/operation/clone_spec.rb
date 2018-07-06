require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Products::Clone do

  let!(:application) { create(:created_seller_version) }
  let!(:current_user) { create(:seller_user, seller: application.seller) }

  let!(:product) {
    create(:product,
      seller: application.seller,
      name: 'Product',
      summary: 'Overview text',
      contact_name: 'Example Name',
      free_version: true,
      free_version_details: 'Free tier available',
    )
  }
  let!(:features) { create_list(:product_feature, 5, product: product) }
  let!(:benefits) { create_list(:product_benefit, 5, product: product) }

  def perform_operation
    described_class.({
      application_id: application.id,
      id: product.id
    }, 'config.current_user' => current_user)
  end

  it 'creates a new product' do
    expect { perform_operation }.to change { Product.count }.from(1).to(2)
  end

  it 'copies attributes from the existing product to the new product' do
    result = perform_operation
    new_product = result[:new_product_model]

    expect(new_product.summary).to eq(product.summary)
    expect(new_product.contact_name).to eq(product.contact_name)
    expect(new_product.free_version).to eq(product.free_version)
    expect(new_product.free_version_details).to eq(product.free_version_details)
  end

  it 'sets a new name for the product' do
    result = perform_operation
    new_product = result[:new_product_model]

    expect(new_product.name).to eq("#{product.name} copy")
  end

  it 'does not copy the "created_at" or "updated_at" fields' do
    # NOTE: Freeze the time here so that the updated_at timestamp for the new
    # products will be set differently
    #
    Timecop.freeze(1.day.from_now) do
      result = perform_operation
      new_product = result[:new_product_model]

      expect(new_product.created_at.to_i).to_not eq(product.created_at.to_i)
      expect(new_product.updated_at.to_i).to_not eq(product.updated_at.to_i)
    end
  end

  it 'does not copy the "state" field' do
    product.make_active!

    result = perform_operation
    new_product = result[:new_product_model]

    expect(new_product.state).to eq('inactive')
  end

  it 'copies the features and benefits' do
    result = perform_operation
    new_product = result[:new_product_model]

    expect(new_product.features.count).to eq(features.count)
    expect(new_product.benefits.count).to eq(benefits.count)
  end

  it 'copies documents' do
    product.terms_file = Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
      'application/pdf'
    )
    product.save!

    result = perform_operation
    new_product = result[:new_product_model]

    expect(new_product.documents.count).to eq(product.documents.count)
    expect(new_product.documents.first.kind).to eq(product.documents.first.kind)
  end

  describe 'finding the product' do
    it 'fails with an empty user' do
      result = described_class.({
        application_id: application.id,
        id: product.id
      }, 'config.current_user' => nil)

      expect(result).to be_failure
      expect(Product.count).to eq(1)
    end

    it 'fails with a different user' do
      other_user = create(:seller_user)

      expect {
        described_class.({
          application_id: application.id,
          id: product.id
        }, 'config.current_user' => other_user)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'fails given a product from a different seller' do
      other_product = create(:product)

      expect {
        described_class.({
          application_id: application.id,
          id: other_product.id
        }, 'config.current_user' => current_user)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
