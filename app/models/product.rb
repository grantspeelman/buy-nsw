class Product < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::Documentable
  include Concerns::StateScopes

  belongs_to :seller

  has_documents :terms

  has_many :benefits, class_name: 'ProductBenefit'
  has_many :features, class_name: 'ProductFeature'
  has_many :seller_versions, through: :seller, source: :versions

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
  enumerize :pricing_currency, in: ['aud', 'usd', 'other']
  enumerize :deployment_model, multiple: true, in: ['govdc', 'public-cloud', 'other-cloud']
  enumerize :addon_extension_type, in: ['yes', 'yes-and-standalone', 'no']
  enumerize :api, in: ['rest', 'non-rest', 'no']
  enumerize :government_network_type, multiple: true, in: ['govdc', 'govlink', 'aarnet', 'id-hub', 'icon', 'other']
  enumerize :supported_browsers, multiple: true, in: [
    'ie7', 'ie8', 'ie9', 'ie10', 'ie11', 'ms-edge', 'firefox', 'chrome', 'safari9', 'opera'
  ]
  enumerize :supported_os, multiple: true, in: [
    'windows', 'macos', 'linux-unix', 'android', 'ios', 'windows-phone', 'other'
  ]
  enumerize :accessibility_type, in: ['all', 'exclusions', 'none']
  enumerize :scaling_type, in: ['automatic', 'manual', 'none']
  enumerize :support_options, multiple: true, in: ['phone', 'email', 'web-chat', 'online', 'onsite']

  enumerize :data_import_formats, multiple: true, in: ['csv', 'odf', 'json', 'xml', 'other']
  enumerize :data_export_formats, multiple: true, in: ['csv', 'odf', 'json', 'xml', 'other']
  enumerize :data_location, in: ['australia-default', 'australia-request', 'other-known', 'dont-know']

  enumerize :backup_capability, in: ['everything', 'user-controlled', 'supplier-controlled']
  enumerize :backup_scheduling_type, in: ['user-controlled', 'supplier-controlled']
  enumerize :backup_recovery_type, in: ['self-managed', 'contact-support']

  enumerize :encryption_transit_user_types, multiple: true, in: ['private-or-gov-network', 'tls', 'legacy-ssl-tls', 'vpn', 'other']
  enumerize :encryption_transit_network_types, multiple: true, in: ['tls', 'legacy-ssl-tls', 'vpn', 'other']
  enumerize :encryption_rest_types, multiple: true, in: ['physical-csa-ccm-v3', 'physical-ssae-18', 'physical-other', 'encryption-physical-media', 'obfuscating', 'other']
  enumerize :encryption_keys_controller, in: ['none', 'supplier', 'buyer']

  enumerize :authentication_types, multiple: true, in: ['username-password', '2fa', 'public-key', 'federation', 'government-network', 'dedicated-link', 'other']
  enumerize :access_testing_frequency, in: ['at-least-6-months', 'at-least-once-year', 'less-than-once-year', 'never']

  enumerize :data_centre_security_standards, in: ['recognised-standard', 'supplier-defined', 'third-party']
  enumerize :csa_star_level, in: ['level-1', 'level-2', 'level-3', 'level-4', 'level-5']
  enumerize :irap_type, in: ['stages-1-and-2', 'stage-1', 'not-assessed']
  enumerize :security_classification_types, multiple: true, in: ['unclassified-dlm', 'protected', 'secret', 'top-secret']

  enumerize :virtualisation_implementor, in: ['supplier', 'third-party']
  enumerize :virtualisation_technologies, multiple: true, in: ['vmware','hyper-v','citrix-xenserver','oracle-vm','red-hat-virtualisation','kvm-hypervisor','other']

  enumerize :secure_development_approach, in: ['independently-assessed', 'self-assessed', 'supplier-defined']
  enumerize :penetration_testing_frequency, in: ['at-least-6-months', 'at-least-once-year', 'less-than-once-year', 'never']
  enumerize :penetration_testing_approach, multiple: true, in: ['crest-approved', 'other-external', 'in-house', 'none']

  enumerize :change_management_processes, in: ['recognised-standard', 'supplier-defined']
  enumerize :vulnerability_processes, in: ['recognised-standard', 'supplier-defined', 'undisclosed']
  enumerize :protective_monitoring_processes, in: ['recognised-standard', 'supplier-defined', 'undisclosed']
  enumerize :incident_management_processes, in: ['recognised-standard', 'supplier-defined']
  enumerize :access_control_testing_frequency, in: ['6-months', 'yearly', 'less-than-yearly', 'never']

  enumerize :outage_channel_types, multiple: true, in: ['email', 'sms', 'dashboard', 'api', 'other']
  enumerize :metrics_channel_types, multiple: true, in: ['api', 'real-time', 'regular', 'on-request', 'other']
  enumerize :usage_channel_types, multiple: true, in: ['email', 'sms', 'api', 'other']

  scope :with_section, ->(section){ where("section = :section", section: section) }
  scope :with_audience, ->(audience){ where(":audience = ANY(audiences)", audience: audience) }
  scope :start_up, ->{ joins(:seller_versions).where('seller_versions.start_up' => true) }
  scope :disability, ->{ joins(:seller_versions).where('seller_versions.disability' => true) }
  scope :indigenous, ->{ joins(:seller_versions).where('seller_versions.indigenous' => true) }
  scope :not_for_profit, ->{ joins(:seller_versions).where('seller_versions.not_for_profit' => true) }
  scope :regional, ->{ joins(:seller_versions).where('seller_versions.regional' => true) }
  scope :sme, ->{ joins(:seller_versions).where('seller_versions.sme' => true) }

  scope :reseller, -> { where(reseller_type: ['no-extras', 'extra-support', 'extra-features-support']) }
  scope :not_reseller, -> { where(reseller_type: 'own-product') }
  scope :free_version, -> { where(:free_version => true) }
  scope :free_trial, -> { where(:free_trial => true) }
  scope :education_pricing, -> { where(:education_pricing => true) }
  scope :not_for_profit_pricing, -> { where(:not_for_profit_pricing => true) }
  scope :with_data_location, ->(location){ where(data_location: location) }
  scope :with_data_in_australia, -> { where(data_location: ['australia-default', 'australia-request']) }
  scope :with_api, ->{ where(api: ['rest', 'non-rest']) }
  scope :mobile_devices, ->{ where(mobile_devices: true) }

  scope :with_government_network_type, ->(type) { where(":type = ANY(government_network_type)", type: type) }

  scope :iso_27001, ->{ where(iso_27001: true) }
  scope :iso_27017, ->{ where(iso_27017: true) }
  scope :iso_27018, ->{ where(iso_27018: true) }
  scope :csa_star, ->{ where(csa_star: true) }
  scope :pci_dss, ->{ where(pci_dss: true) }
  scope :soc_2, ->{ where(soc_2: true) }
  scope :irap_assessed, -> { where("irap_type != 'not-assessed'") }
  scope :asd_certified, -> { where(asd_certified: true)}
end
