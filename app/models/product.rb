class Product < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::StateScopes

  belongs_to :seller

  has_many :benefits, class_name: 'ProductBenefit'
  has_many :features, class_name: 'ProductFeature'

  aasm column: :state do
    state :inactive, initial: true
    state :active

    event :make_active do
      transitions from: :inactive, to: :active
    end
  end

  enumerize :section, in: [
    'applications-software',
    'hosting-infrastructure',
    'support-services',
  ]
  enumerize :audiences, multiple: true, in: [
    'accounting-finance',
    'audit-risk-compliance',
    'data-analytics',
    'developers',
    'facilities',
    'human-resource-management',
    'legal',
    'operations-management',
    'projects-team-collaboration',
    'sales-marketing',
    'security-cyber',
  ]
  enumerize :reseller_type, in: ['own-product', 'no-extras', 'extra-support', 'extra-features-support']

  scope :with_section, ->(section){ where("section = :section", section: section) }
  scope :with_audience, ->(audience){ where(":audience = ANY(audiences)", audience: audience) }
  scope :start_up, ->{ joins(:seller).where('sellers.start_up' => true) }
  scope :disability, ->{ joins(:seller).where('sellers.disability' => true) }
  scope :indigenous, ->{ joins(:seller).where('sellers.indigenous' => true) }
  scope :not_for_profit, ->{ joins(:seller).where('sellers.not_for_profit' => true) }
  scope :regional, ->{ joins(:seller).where('sellers.regional' => true) }
  scope :sme, ->{ joins(:seller).where('sellers.sme' => true) }
  scope :start_up, ->{ joins(:seller).where('sellers.start_up' => true) }
end
