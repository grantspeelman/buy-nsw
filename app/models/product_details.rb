class ProductDetails

  def initialize(product)
    @product = product
  end

  def details
    sections.tap {|sections|
      # Filter out empty fields from the list – eg. conditional fields
      #
      sections.each {|key, fields|
        fields.delete_if {|label, value|
          value.nil? || (value.is_a?(Array) && value.empty?)
        }
      }
    }
  end

private
  attr_reader :product

  def sections
    {
      "Onboarding and offboarding" => onboarding_and_offboarding,
      "Environment" => environment,
      "Availability and support" => availability_and_support,
      "User data" => user_data,
      "Identity and authentication" => identity_and_authentication,
      "Security standards" => security_standards,
      "Security practices" => security_practices,
      "Reporting and analytics" => reporting_and_analytics,
    }
  end

  def onboarding_and_offboarding
    {
      "Onboarding assistance" => product.onboarding_assistance,
      "Offboarding assistance" => product.offboarding_assistance,
    }
  end

  def environment
    {
      "Cloud deployment model" => product.deployment_model_text,
      "Software add-on or extension" => product.addon_extension_type_text,
      "Add-on or extension to" => product.addon_extension_details,
      "API" => product.api,
      "What users can and can't do using the API" => product.api_capabilities,
      "Compatible API automation tools" => product.api_automation,
      "API documentation provided" => product.api_documentation,
      "API sandbox provided" => product.api_sandbox,
      "Connected government networks" => product.government_network_type.texts,
      "Other connected government networks" => product.government_network_other,
      "Web interface" => product.web_interface,
      "What users can and can't do using the web interface" => product.web_interface_details,
      "Supported browsers" => product.supported_browsers.texts,
      "Application for users to install" => product.installed_application,
      "Supported operating systems" => product.supported_os.texts,
      "Other supported operating systems" => product.supported_os_other,
      "Designed to work on mobile devices" => product.mobile_devices,
      "Differences in the mobile and desktop functionality" => product.mobile_desktop_differences,
      "Accessible to WCAG 2.0 AA or above" => product.accessibility_type_text,
      "Areas which are accessible (and exclusions)" => product.accessibility_exclusions,
      "How the product or service scales" => product.scaling_type_text,
    }
  end

  def availability_and_support
    {
      "Guaranteed availability (excluding scheduled outages)" => product.guaranteed_availability,
      "Core support options available" => product.support_options.texts,
      "Support hours" => product.support_hours,
      "Support levels" => product.support_levels,
    }
  end


  def user_data
    {
      "Data import formats" => product.data_import_formats.texts,
      "Other data import formats" => product.data_import_formats_other,
      "Data export formats" => product.data_export_formats.texts,
      "Other data export formats" => product.data_export_formats_other,
      "Whether users can access and extract their data at any time" => product.data_access_text,
      "How users access audit information about the actions their users have taken" => product.audit_access_type_text,
      "How long user audit data is stored for" => product.audit_storage_period_text,
      "How long system logs are stored for" => product.log_storage_period_text,
      "Locations where user data is stored, processed and managed" => product.data_location_text,
      "Other known locations" => product.data_location_other,
      "Whether users can control where their data is stored, processed and managed in Australia" => product.data_storage_control_australia,
      "Whether third parties manage the data centres used to provide this product or service" => product.third_party_infrastructure,
      "The third parties managing the data centres" => product.third_party_infrastructure_details,
      "What the service can backup" => product.backup_capability,
      "Disaster recovery set up" => product.disaster_recovery_type_text,
      "How users can schedule backups" => product.backup_scheduling_type_text,
      "How users can recover backups" => product.backup_recovery_type_text,
      "Data protection between buyer and supplier networks" => product.encryption_transit_user_types.texts,
      "Other data protection between buyer and supplier networks" => product.encryption_transit_user_other,
      "Data protection within the supplier's network" => product.encryption_transit_network_types.texts,
      "Other data protection within the supplier's network" => product.encryption_transit_network_other,
      "Data protection at rest" => product.encryption_rest_types.texts,
      "Other data protection at rest" => product.encryption_rest_other,
    }
  end

  def identity_and_authentication
    {
      "User authentication needed" => product.authentication_required,
      "User authentication" => product.authentication_types.texts,
      "Other user authentication" => product.authentication_other,
    }
  end

  def security_standards
    {
      "Data centre security standards" => product.data_centre_security_standards_text,
      "ISO/IEC 27001:2013 certification" => product.iso_27001,
      "Who accredited the ISO/IEC 27001:2013 certification" => product.iso_27001_accreditor,
      "When the ISO/IEC 27001:2013 certification was accredited" => product.iso_27001_date,
      "What the ISO/IEC 27001:2013 certification doesn't cover" => product.iso_27001_exclusions,
      "ISO/IEC 27017:2015 certification" => product.iso_27017,
      "Who accredited the ISO/IEC 27017:2015 certification" => product.iso_27017_accreditor,
      "When the ISO/IEC 27017:2015 certification was accredited" => product.iso_27017_date,
      "What the ISO/IEC 27017:2015 certification doesn't cover" => product.iso_27017_exclusions,
      "ISO/IEC 27018:2014 certification" => product.iso_27018,
      "Who accredited the ISO/IEC 27018:2014 certification" => product.iso_27018_accreditor,
      "When the ISO/IEC 27018:2014 certification was accredited" => product.iso_27018_date,
      "What the ISO/IEC 27018:2014 certification doesn't cover" => product.iso_27018_exclusions,
      "CSA STAR certification" => product.csa_star,
      "Who accredited the CSA STAR certification" => product.csa_star_accreditor,
      "When the CSA STAR certification was accredited" => product.csa_star_date,
      "CSA STAR level" => product.csa_star_level_text,
      "What the CSA STAR certification doesn't cover" => product.csa_star_exclusions,
      "PCI DSS certification" => product.pci_dss,
      "Who accredited the PCI DSS certification" => product.pci_dss_accreditor,
      "When the PCI DSS certification was accredited" => product.pci_dss_date,
      "What the PCI DSS certification doesn't cover" => product.pci_dss_exclusions,
      "SOC I certification" => product.soc_1,
      "SOC II certification" => product.soc_2,
    }
  end

  def security_practices
    {
      "Approach to secure software development best practice" => product.secure_development_approach_text,
      "How often the supplier conducts penetration testing" => product.penetration_testing_frequency_text,
      "The supplier's approach to penetration testing" => product.penetration_testing_approach_text,
    }
  end

  def reporting_and_analytics
    {
      "Metrics reported" => product.metrics_contents,
      "Reporting types" => product.metrics_channel_types.texts,
      "Other reporting types" => product.metrics_channel_other,
      "Outage reporting" => product.outage_channel_types.texts,
      "Other outage reporting" => product.outage_channel_other,
      "Usage reporting" => product.usage_channel_types.texts,
      "Other usage reporting" => product.usage_channel_other,
    }
  end

end
