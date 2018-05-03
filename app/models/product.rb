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

  enumerize :data_import_formats, multiple: true, in: ['csv', 'odf', 'other']
  enumerize :data_export_formats, multiple: true, in: ['csv', 'odf', 'other']
  enumerize :data_access, in: ['unrestricted', 'restrictions', 'no']
  enumerize :audit_access_type, in: ['real-time', 'regular', 'manual']
  enumerize :audit_storage_period, in: ['user-defined', '12-months', '6-to-12-months', '1-to-6-months', 'less-than-1-month', 'supplier-controlled', 'none']
  enumerize :log_storage_period, in: ['user-defined', '12-months', '6-to-12-months', '1-to-6-months', 'less-than-1-month']
  enumerize :data_location, in: ['only-australia', 'other-known', 'dont-know']
  enumerize :disaster_recovery_type, in: ['multiple-dc-with-dr', 'single-dc-with-copies', 'multiple-dc', 'single-dc']
  enumerize :backup_scheduling_type, in: ['web-interface', 'contact-support', 'supplier-controlled']
  enumerize :backup_recovery_type, in: ['self-managed', 'contact-support']
  enumerize :encryption_transit_user_types, multiple: true, in: ['private-or-gov-network', 'tls', 'legacy-ssl-tls', 'vpn', 'bonded-fibre', 'other']
  enumerize :encryption_transit_network_types, multiple: true, in: ['tls', 'legacy-ssl-tls', 'vpn', 'other']
  enumerize :encryption_rest_types, multiple: true, in: ['physical-csa-ccm-v3', 'physical-ssae-16', 'physical-other', 'encryption-physical-media', 'obfuscating', 'other']

  enumerize :authentication_types, multiple: true, in: ['username-password', '2fa', 'public-key', 'federation', 'government-network', 'dedicated-link', 'other']
  enumerize :access_testing_frequency, in: ['at-least-6-months', 'at-least-once-year', 'less-than-once-year', 'never']

  enumerize :data_centre_security_standards, in: ['recognised-standard', 'supplier-defined', 'third-party']
  enumerize :csa_star_level, in: ['level-1', 'level-2', 'level-3', 'level-4', 'level-5']

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
