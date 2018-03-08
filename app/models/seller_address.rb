class SellerAddress < ApplicationRecord
  extend Enumerize

  belongs_to :seller

  enumerize :state, in: [ :nsw, :act, :nt, :qld, :sa, :tas, :vic, :wa ]
end
