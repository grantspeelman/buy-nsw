class ProductDetails

  def initialize(product, include_all: false)
    @product = product
    @include_all = include_all
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
  attr_reader :product, :include_all

  def sections
    include_all ? additional_sections.merge(core_sections) : core_sections
  end

  def core_sections
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

  def additional_sections
    {
      "Product basics" => product_basics,
      "Commercials" => commercials,
    }
  end

  def product_basics
    {
      "Name" => product.name,
      "Summary" => product.summary,
      "Audiences" => product.audiences.texts,
      "Features" => product.features.map(&:feature),
      "Benefits" => product.benefits.map(&:benefit),
      "Reseller status" => product.reseller_type_text,
      "Organisation resold" => product.organisation_resold,
      "Product-specific contact details" => product.custom_contact,
      "Product contact name" => product.contact_name,
      "Product contact email" => product.contact_email,
      "Product contact phone" => product.contact_phone,
    }
  end

  def commercials
    {
      "Free version available" => product.free_version,
      "Free version details" => product.free_version_details,
      "Free trial available" => product.free_trial,
      "Free trial URL" => product.free_trial_url,
      "Minimum price" => product.pricing_min,
      "Maximum price" => product.pricing_max,
      "Pricing unit" => product.pricing_unit,
      "Variables affecting pricing" => product.pricing_variables,
      "Pricing calculator URL" => product.pricing_calculator_url,
      "Education pricing available" => product.education_pricing,
      "Education pricing eligibility" => product.education_pricing_eligibility,
      "Education pricing differences" => product.education_pricing_differences,
      "Not-for-profit pricing available" => product.not_for_profit_pricing,
      "Not-for-profit pricing eligibility" => product.not_for_profit_pricing_eligibility,
      "Not-for-profit pricing differences" => product.not_for_profit_pricing_differences,
    }
  end

  def onboarding_and_offboarding
    {
      "Onboarding assistance" => product.onboarding_assistance,
      "Offboarding assistance" => product.offboarding_assistance,
    }
  end

  def environment
    attributes do |a|
      a["Cloud deployment model"] = product.deployment_model_text
      a["Software add-on or extension"] = product.addon_extension_type_text

      if ['yes', 'yes-and-standalone'].include?(product.addon_extension_type)
        a["Add-on or extension to"] = product.addon_extension_details
      end

      a["API"] = product.api

      if product.api
        a["What users can and can't do using the API"] = product.api_capabilities
        a["Compatible API automation tools"] = product.api_automation
        a["API documentation provided"] = product.api_documentation
        a["API sandbox provided"] = product.api_sandbox
      end

      a["Connected government networks"] = product.government_network_type.texts

      if product.government_network_type.include?('other')
        a["Other connected government networks"] = product.government_network_other
      end

      a["Web interface"] = product.web_interface

      if product.web_interface
        a["What users can and can't do using the web interface"] = product.web_interface_details
        a["Supported browsers"] = product.supported_browsers.texts
      end

      a["Application for users to install"] = product.installed_application

      if product.installed_application
        a["Supported operating systems"] = product.supported_os.texts

        if product.supported_os.include?('other')
          a["Other supported operating systems"] = product.supported_os_other
        end
      end

      a["Designed to work on mobile devices"] = product.mobile_devices

      if product.mobile_devices
        a["Differences in the mobile and desktop functionality"] = product.mobile_desktop_differences
      end

      a["Accessible to WCAG 2.0 AA or above"] = product.accessibility_type_text

      if product.accessibility_type == 'exclusions'
        a["Areas which are accessible (and exclusions)"] = product.accessibility_exclusions
      end

      a["How the product or service scales"] = product.scaling_type_text
    end
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
    attributes do |a|
      a["Data import formats"] = product.data_import_formats.texts

      if product.data_import_formats.include?('other')
        a["Other data import formats"] = product.data_import_formats_other
      end

      a["Data export formats"] = product.data_export_formats.texts

      if product.data_export_formats.include?('other')
        a["Other data export formats"] = product.data_export_formats_other
      end

      a["Whether users can access and extract their data at any time"] = product.data_access_text
      a["How users access audit information about the actions their users have taken"] = product.audit_access_type_text
      a["How long user audit data is stored for"] = product.audit_storage_period_text
      a["How long system logs are stored for"] = product.log_storage_period_text
      a["Locations where user data is stored, processed and managed"] = product.data_location_text

      if product.data_location == 'other-known'
        a["Other known locations"] = product.data_location_other
      end

      a["Whether users can control where their data is stored, processed and managed in Australia"] = product.data_storage_control_australia
      a["Whether third parties manage the data centres used to provide this product or service"] = product.third_party_infrastructure

      if product.third_party_infrastructure
        a["The third parties managing the data centres"] = product.third_party_infrastructure_details
      end

      a["What the service can backup"] = product.backup_capability
      a["Disaster recovery set up"] = product.disaster_recovery_type_text
      a["How users can schedule backups"] = product.backup_scheduling_type_text
      a["How users can recover backups"] = product.backup_recovery_type_text
      a["Data protection between buyer and supplier networks"] = product.encryption_transit_user_types.texts

      if product.encryption_transit_user_types.include?('other')
        a["Other data protection between buyer and supplier networks"] = product.encryption_transit_user_other
      end

      a["Data protection within the supplier's network"] = product.encryption_transit_network_types.texts

      if product.encryption_transit_network_types.include?('other')
        a["Other data protection within the supplier's network"] = product.encryption_transit_network_other
      end

      a["Data protection at rest"] = product.encryption_rest_types.texts

      if product.encryption_rest_types.include?('other')
        a["Other data protection at rest"] = product.encryption_rest_other
      end
    end
  end

  def identity_and_authentication
    attributes do |a|
      a["User authentication needed"] = product.authentication_required

      if product.authentication_required
        a["User authentication"] = product.authentication_types.texts
        a["Other user authentication"] = product.authentication_other
      end
    end
  end

  def security_standards
    attributes do |a|
      a["Data centre security standards"] = product.data_centre_security_standards_text
      a["ISO/IEC 27001:2013 certification"] = product.iso_27001

      if product.iso_27001
        a["Who accredited the ISO/IEC 27001:2013 certification"] = product.iso_27001_accreditor
        a["When the ISO/IEC 27001:2013 certification was accredited"] = product.iso_27001_date
        a["What the ISO/IEC 27001:2013 certification doesn't cover"] = product.iso_27001_exclusions
      end

      a["ISO/IEC 27017:2015 certification"] = product.iso_27017

      if product.iso_27017
        a["Who accredited the ISO/IEC 27017:2015 certification"] = product.iso_27017_accreditor
        a["When the ISO/IEC 27017:2015 certification was accredited"] = product.iso_27017_date
        a["What the ISO/IEC 27017:2015 certification doesn't cover"] = product.iso_27017_exclusions
      end

      a["ISO/IEC 27018:2014 certification"] = product.iso_27018

      if product.iso_27018
        a["Who accredited the ISO/IEC 27018:2014 certification"] = product.iso_27018_accreditor
        a["When the ISO/IEC 27018:2014 certification was accredited"] = product.iso_27018_date
        a["What the ISO/IEC 27018:2014 certification doesn't cover"] = product.iso_27018_exclusions
      end

      a["CSA STAR certification"] = product.csa_star

      if product.csa_star
        a["Who accredited the CSA STAR certification"] = product.csa_star_accreditor
        a["When the CSA STAR certification was accredited"] = product.csa_star_date
        a["CSA STAR level"] = product.csa_star_level_text
        a["What the CSA STAR certification doesn't cover"] = product.csa_star_exclusions
      end

      a["PCI DSS certification"] = product.pci_dss

      if product.pci_dss
        a["Who accredited the PCI DSS certification"] = product.pci_dss_accreditor
        a["When the PCI DSS certification was accredited"] = product.pci_dss_date
        a["What the PCI DSS certification doesn't cover"] = product.pci_dss_exclusions
      end

      a["SOC I certification"] = product.soc_1
      a["SOC II certification"] = product.soc_2
    end
  end

  def security_practices
    {
      "Approach to secure software development best practice" => product.secure_development_approach_text,
      "How often the supplier conducts penetration testing" => product.penetration_testing_frequency_text,
      "The supplier's approach to penetration testing" => product.penetration_testing_approach_text,
    }
  end

  def reporting_and_analytics
    attributes do |a|
      a["Metrics reported"] = product.metrics_contents
      a["Reporting types"] = product.metrics_channel_types.texts

      if product.metrics_channel_types.include?('other')
        a["Other reporting types"] = product.metrics_channel_other
      end

      a["Outage reporting"] = product.outage_channel_types.texts

      if product.outage_channel_types.include?('other')
        a["Other outage reporting"] = product.outage_channel_other
      end

      a["Usage reporting"] = product.usage_channel_types.texts

      if product.usage_channel_types.include?('other')
        a["Other usage reporting"] = product.usage_channel_other
      end
    end
  end

  def attributes(&block)
    {}.tap(&block)
  end

end
