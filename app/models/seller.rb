class Seller < ApplicationRecord
  include AASM
  extend Enumerize

  belongs_to :owner, class_name: 'User'

  has_many :accreditations, class_name: 'SellerAccreditation', dependent: :destroy
  has_many :addresses, class_name: 'SellerAddress', dependent: :destroy
  has_many :applications, class_name: 'SellerApplication'
  has_many :awards, class_name: 'SellerAward', dependent: :destroy
  has_many :engagements, class_name: 'SellerEngagement', dependent: :destroy

  aasm column: :state do
    state :inactive, initial: true
    state :active
  end

  enumerize :industry, multiple: true, in: ['ict', 'construction', 'other']
  enumerize :number_of_employees, in: ['sole', '2to19', '20to49', '50to99', '100to199', '200plus']
  enumerize :services, multiple: true, in: [
    'advisory-consulting',
    'cloud-services',
    'data-analytics',
    'emerging-technology',
    'end-user-computing',
    'ict-workforce',
    'infrastructure',
    'managed-services',
    'project-program-management',
    'security-identity',
    'software-development',
    'software-licensing',
    'telecommunications',
    'training-learning',
  ]

  mount_uploader :financial_statement, FinancialStatementUploader
  mount_uploader :professional_indemnity_certificate, ProfessionalIndemnityCertificateUploader
  mount_uploader :workers_compensation_certificate, WorkersCompensationCertificateUploader
end
