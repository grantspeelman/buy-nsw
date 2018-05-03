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
  enumerize :pricing_variables, multiple: true, in: [
    'user-numbers',
    'volumes',
    'term-commitment',
    'geographic-location',
    'data-extraction',
    'other',
  ]
  enumerize :deployment_model, in: ['private-cloud', 'public-cloud']
  enumerize :addon_extension_type, in: ['yes', 'yes-and-standalone', 'no']
  enumerize :government_network_type, multiple: true, in: ['govdc', 'id-hub', 'other']
  enumerize :supported_browsers, multiple: true, in: [
    'ie7', 'ie8', 'ie9', 'ie10', 'ie11', 'ms-edge', 'firefox', 'chrome', 'safari9', 'opera'
  ]
  enumerize :supported_os, multiple: true, in: [
    'windows', 'macos', 'linux-unix', 'android', 'ios', 'windows-phone', 'other'
  ]
  enumerize :accessibility_type, in: ['all', 'exclusions', 'none']
  enumerize :scaling_type, in: ['automatic', 'manual', 'none']
  enumerize :support_options, multiple: true, in: ['phone', 'email', 'web-chat', 'online', 'onsite']

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
