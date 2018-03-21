class MockProductDetails

  def details
    {
      "Service scope" => service_scope,
      "User support" => user_support,
      "Onboarding and offboarding" => onboarding_and_offboarding,
      "Using the service" => using_the_service,
      "Scaling" => scaling,
      "Analytics" => analytics,
      "Resellers" => resellers,
      "Staff security" => staff_security,
      "Asset protection" => asset_protection,
      "Data importing and exporting" => data_importing_and_exporting,
      "Backup and hosting" => {},
      "Data-in-transit protection" => data_in_transit_protection,
      "Availability and resilience" => availability_and_resilience,
      "Identity and authentication" => identity_and_authentication,
      "Audit information for users" => audit_information_for_users,
      "Standards and certifications" => standards_and_certifications,
      "Security governance" => security_governance,
      "Operational security" => operational_security,
      "Secure development" => secure_development,
      "Public sector networks" => public_sector_networks,
      "Pricing" => pricing,
    }
  end

private
  def service_scope
    {
      "Software add-on or extension" => "No",
      "Cloud deployment model" => "Public cloud",
      "Service constraints" => "None",
      "System requirements" => "Access to the internet via browser"
    }
  end

  def user_support
    {
      "Email or online ticketing support" => "Email or online ticketing",
      "Support response times" => "Contract dependant",
      "User can manage status and priority of support tickets" => "Yes",
      "Phone support" => "Yes",
      "Phone support availability" => "9am to 5pm AEST, Monday to Friday",
      "Web chat support" => "Yes",
      "Web chat support accessibility standard" => "No",
      "Web chat support accessibility testing" => "None",
      "Onsite support" => "Urgent only",
      "Support levels" => "	All Customers are assigned a dedicated Account Manager.\nStandard Support is UK business hours Mon-Friday 9 am to 5:30 pm.\nSupport can be accessed either via email or by Phone\n24/7 Support is available at an extra cost.",
      "Support available to third parties" => "No",
    }
  end

  def onboarding_and_offboarding
    {
      "Getting started" => "Most deployments require a Statement of Work to help implement existing process into the Prevalent application. Each SOW includes knowledge transfer to hand the application over.",
      "Service documentation" => "Yes",
      "Documentation formats" => "HTML",
      "End-of-contract data extraction" => "Data can be extracted in CSV format",
      "End-of-contract process" => "At the termination of a contract all access to the SaaS software will be revoked to use the software and the clients will have up to 60 days to export all data from the repository before data is deleted. A series of notifications will commence to remind clients to export all relevant data.",
    }
  end

  def using_the_service
    {
      "Web browser interface" => "Yes",
      "Supported browsers" => [
          "Internet Explorer 9",
          "Internet Explorer 10+",
          "Microsoft Edge",
          "Firefox",
          "Chrome",
          "Safari 9+",
          "Opera",
      ],
      "Application to install" => "No",
      "Designed for use on mobile devices" => "Yes",
      "Differences between the mobile and desktop service" => "None, the interface is fully responsive",
      "Accessibility standards" => "WCAG 2.0 AA compliant",
      "Accessibility testing" => "All new functionality includes regular accessibility testing",
      "API" => "Yes",
      "What users can and can't do using the API" => "Users can read all client data from the service",
      "API documentation" => "Yes",
      "API documentation formats" => "Parchment",
      "API sandbox or test environment" => "Yes",
      "Customisation available" => "No",
    }
  end

  def scaling
    {
      "Independence of resources" => "Where we provide the platform via dedicated SaaS each instance is run independently of any other. On our multi-tenanted model, safeguards are built into the installation so they can't affect other clients.",
    }
  end

  def analytics
    {
      "Reporting types" => "Real-time dashboards are available to all users",
      "Metric types" => "Transaction volume available to the minute",
    }
  end

  def resellers
    {
      "Supplier type" => "Not a reseller",
    }
  end

  def staff_security
    {
      "Staff security clearance" => "Other clearance",
      "Government security clearance" => "Up to Positive Vetting (PV)",
    }
  end

  def asset_protection
    {
      "Knowledge of data storage and processing locations" => "Yes",
      "Data storage and processing locations" => "Australia",
      "User control over data storage and processing locations" => "No",
      "Datacentre security standards" => "Complies with a recognised standard (for example CSA CCM version 3.0)",
      "Penetration testing frequency" => "At least every 6 months",
      "Penetration testing approach" => "Another external penetration testing organisation",
      "Protecting data at rest" => [
        "Physical access control, complying with SSAE-16 / ISAE 3402",
        "Physical access control, complying with another standard",
      ],
      "Data sanitisation process" => "Yes",
      "Data sanitisation type" => "Explicit overwriting of storage before reallocation",
      "Equipment disposal approach" => "Complying with a recognised standard, for example CSA CCM v.30, CAS (Sanitisation) or ISO/IEC 27001",
    }
  end

  def data_importing_and_exporting
    {
      "Data export approach" => "Clients can extract their data from the platform at anytime in a flat file format (e.g. .csv). Where a client instance is integrated to any third party application via web services then specific ranges of data are being extracted to separate database applications at a frequency that can be set by the client e.g. every 15 or 30 minutes",
      "Data export formats" => [
        "CSV",
        "Other"
      ],
      "Other data export formats" => "XML (subject to web services security constraints)",
      "Data import formats" => [
        "CSV",
        "Other",
      ],
      "Other data import formats" => "XML (subject to web services security constraints)",
    }
  end

  def data_in_transit_protection
    {
      "Data protection between buyer and supplier networks" => "TLS (version 1.2 or above)",
      "Data protection within supplier network" => "TLS (version 1.2 or above)",
    }
  end

  def availability_and_resilience
    {
      "Guaranteed availability" => "The service will be available 99% of the time including Scheduled and Unscheduled maintenance. This excludes Unscheduled maintenance due to malicious attack.",
      "Approach to resilience" => "Fully mirrored architecture hosted in separate geographical locations.",
      "Outage reporting" => "Email alerts.",
    }
  end

  def identity_and_authentication
    {
      "User authentication needed" => "Yes",
      "User authentication" => "Username or password",
      "Access restrictions in management interfaces and support channels" => "Limited users. Username and password.",
      "Access restriction testing frequency" => "At least every 6 months",
      "Management access authentication" => "Username or password",
    }
  end

  def audit_information_for_users
    {
      "Access to user activity audit information" => "Users contact the support team to get audit information",
      "How long user audit data is stored for" => "At least 12 months",
      "Access to supplier activity audit information" => "Users contact the support team to get audit information",
      "How long supplier audit data is stored for" => "At least 12 months",
      "How long system logs are stored for" => "Between 1 month and 6 months",
    }
  end

  def standards_and_certifications
    {
      "ISO/IEC 27001 certification" => "Yes",
      "Who accredited the ISO/IEC 27001" => "Accredit-O-Matic Ltd",
      "ISO/IEC 27001 accreditation date" => "05/04/2017",
      "What the ISO/IEC 27001 doesn’t cover" => "N/A",
      "ISO 28000:2007 certification" => "No",
      "CSA STAR certification" => "No",
      "PCI certification" => "No",
      "Other security accreditations" => "Yes",
      "Any other security accreditations" => "Certified Gold",
    }
  end

  def security_governance
    {
      "Named board-level person responsible for service security" => "Yes",
      "Security governance accreditation" => "Yes",
      "Security governance standards" => [
        "ISO/IEC 27001",
        "Other",
      ],
      "Other security governance standards" => "Certified Gold",
      "Information security policies and processes" => "ISO Accreditation policies",
    }
  end

  def operational_security
    {
      "Configuration and change management standard" => "Conforms to a recognised standard, for example CSA CCM v3.0 or SSAE-16 / ISAE 3402",
      "Configuration and change management approach" => "Change Management of network and infrastructure equipment is part of our ISMS based on the ISO27001:3013 standards. Changes are categorised depending on their impact and risk and are approved or rejected by change advisory boards consisting of members of the business responsible of the infrastructure in question as well as reps of other business areas or customers which could be affected by the change. Normal changes require a full testing and rollback plan as well as scheduled notification for the affected parties. Where possible, changes are managed using automated configuration Management systems",
      "Vulnerability management type" => "Conforms to a recognised standard, for example CSA CCM v3.0 or SSAE-16 / ISAE 3402",
      "Vulnerability management approach" => "We have a security incident response plan which is used to respond to potential inicidents. These are classified by the severity and type. the combination of which is used to decide on the approach to analysing, mitigating and resolving the vulnerability",
      "Protective monitoring type" => "Supplier-defined controls",
      "Protective monitoring approach" => "We use various internal/external monitoring systems eg Pingdom, ThousandEyes, Nagios. Network traffic is monitored at the edge of our network using an intrusion detection system as well as on separate stateful firewalls",
      "Incident management type" => "Conforms to a recognised standard, for example, CSA CCM v3.0 or ISO/IEC 27035:2011 or SSAE-16 / ISAE 3402",
      "Incident management approach" => "We have a major incident management process which covers roles, responsibilities and actions for staff when managing a major incident. Users may report an incident over the phone or via our ticketing system. If an incident is deemed major or an SLA breach occurs all affected customers will be provided an incident report to their registered contact",
    }
  end

  def secure_development
    {
      "Approach to secure software development best practice" => "Conforms to a recognised standard, but self-assessed",
    }
  end

  def public_sector_networks
    {
      "Connection to public sector networks" => "No",
    }
  end

  def pricing
    {
      "Price" => "$40 per unit per year",
      "Discount for educational organisations" => "No",
      "Free trial available" => "No",
    }
  end

end
