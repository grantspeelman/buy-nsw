class User < ApplicationRecord
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable,
         :trackable, :validatable, :async, :zxcvbnable,
         :timeoutable

  enumerize :roles, in: ['seller', 'buyer', 'admin'], multiple: true

  has_one :buyer
  belongs_to :seller, optional: true

  has_many :seller_versions, through: :seller, source: :versions
  has_many :assigned_versions, class_name: 'SellerVersion', foreign_key: :assigned_to_id

  def has_seller_version?
    seller_versions.any?
  end

  def is_admin?
    roles.include?('admin')
  end

  def is_buyer?
    roles.include?('buyer')
  end

  def is_active_buyer?
    is_buyer? && buyer.present? && buyer.active?
  end

  def is_seller?
    roles.include?('seller')
  end

  scope :with_role, ->(role) { where(":role = ANY(roles)", role: role) }
  scope :admin, ->{ with_role('admin') }
  scope :seller, ->{ with_role('seller') }
  scope :buyer, ->{ with_role('buyer') }

  scope :unconfirmed, ->{ where('confirmed_at IS NULL') }
end
