class Seller < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::Documentable
  include Concerns::StateScopes

  has_many :owners, class_name: 'User'

  has_many :accreditations, class_name: 'SellerAccreditation', dependent: :destroy
  has_many :addresses, class_name: 'SellerAddress', dependent: :destroy
  has_many :applications, class_name: 'SellerApplication'
  has_many :awards, class_name: 'SellerAward', dependent: :destroy
  has_many :documents, as: :documentable, autosave: true, dependent: :destroy
  has_many :engagements, class_name: 'SellerEngagement', dependent: :destroy
  has_many :products

  has_documents :financial_statement, :professional_indemnity_certificate,
                :workers_compensation_certificate

  before_save :normalise_abn

  aasm column: :state do
    state :inactive, initial: true
    state :active

    event :make_active do
      transitions from: :inactive, to: :active
    end
  end

  enumerize :industry, multiple: true, in: ['ict', 'construction', 'other']
  enumerize :number_of_employees, in: ['sole', '2to4', '5to19', '20to49', '50to99', '100to199', '200plus']
  enumerize :services, multiple: true, in: [
    'cloud-services',
    'software-development',
    'software-licensing',
    'end-user-computing',
    'infrastructure',
    'telecommunications',
    'managed-services',
    'advisory-consulting',
    'ict-workforce',
    'training-learning',
  ]

  scope :disability, ->{ where(disability: true) }
  scope :indigenous, ->{ where(indigenous: true) }
  scope :not_for_profit, ->{ where(not_for_profit: true) }
  scope :regional, ->{ where(regional: true) }
  scope :sme, ->{ where(sme: true) }
  scope :start_up, ->{ where(start_up: true) }
  scope :with_service, ->(service){ where(":service = ANY(services)", service: service) }

  def application_in_progress?
    applications.created.any?
  end

  private

    def normalise_abn
      self.abn = ABN.new(abn).to_s if ABN.valid?(abn)
    end
end
