class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable,
         :trackable, :validatable

  enumerize :roles, in: ['seller', 'admin'], multiple: true, default: :seller

  has_many :sellers, foreign_key: :owner_id
  has_many :seller_applications, foreign_key: :owner_id
  has_many :assigned_applications, class_name: 'SellerApplication', foreign_key: :assigned_to_id

  def has_seller_application?
    seller_applications.any?
  end

  def is_admin?
    roles.include?('admin')
  end
end
