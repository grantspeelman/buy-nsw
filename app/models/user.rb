class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable,
         :trackable, :validatable

  enumerize :roles, in: ['seller', 'buyer', 'admin'], multiple: true

  has_one :buyer
  has_one :seller, foreign_key: :owner_id
  has_many :seller_applications, through: :seller, source: :applications
  has_many :assigned_applications, class_name: 'SellerApplication', foreign_key: :assigned_to_id

  def has_seller_application?
    seller_applications.any?
  end

  def is_admin?
    roles.include?('admin')
  end

  def is_buyer?
    roles.include?('buyer')
  end

  def is_seller?
    roles.include?('seller')
  end

  scope :with_role, ->(role) { where(":role = ANY(roles)", role: role) }
  scope :admin, ->{ with_role('admin') }
  scope :seller, ->{ with_role('seller') }
  scope :buyer, ->{ with_role('buyer') }
end
