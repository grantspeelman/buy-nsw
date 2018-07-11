class Seller < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::Documentable
  include Concerns::SellerVersionAliases
  include Concerns::StateScopes

  has_many :owners, class_name: 'User'
  belongs_to :agreed_by, class_name: 'User', optional: true

  has_one :waiting_seller

  has_many :accreditations, class_name: 'SellerAccreditation', dependent: :destroy
  has_many :addresses, class_name: 'SellerAddress', dependent: :destroy
  has_many :awards, class_name: 'SellerAward', dependent: :destroy
  has_many :engagements, class_name: 'SellerEngagement', dependent: :destroy
  has_many :products
  has_many :versions, class_name: 'SellerVersion'

  has_documents :financial_statement, :professional_indemnity_certificate,
                :workers_compensation_certificate,
                :product_liability_certificate

  aasm column: :state do
    state :inactive, initial: true
    state :active

    event :make_active do
      transitions from: :inactive, to: :active
    end
  end

  def version_in_progress?
    versions.created.any?
  end

  def first_version
    versions.first
  end
end
