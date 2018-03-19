class Product < ApplicationRecord
  include AASM
  
  belongs_to :seller

  aasm column: :state do
    state :inactive, initial: true
    state :active
  end
end
