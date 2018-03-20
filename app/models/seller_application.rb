class SellerApplication < ApplicationRecord
  include AASM

  belongs_to :owner, class_name: 'User'
  belongs_to :seller

  aasm column: :state do
    state :created, initial: true
    state :submitted
    state :approved
    state :rejected

    event :submit do
      # NOTE: This is a temporary change to automatically approve any new
      # seller applications at the current time.
      #
      transitions from: :created, to: :approved

      after_commit do
        seller.make_active!
        seller.products.each(&:make_active!)
      end
    end
  end
end
