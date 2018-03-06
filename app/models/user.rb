class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable,
         :trackable, :validatable

  has_many :sellers, foreign_key: :owner_id
  has_many :seller_applications, foreign_key: :owner_id

  def has_seller_application?
    seller_applications.any?
  end
end
