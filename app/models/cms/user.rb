class Cms::User

  # Includes
  include Mongoid::Document

  # Devise
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Fields
  # ... by Devise

  # Protect attributes
  attr_accessible :email, :password, :password_confirmation

end
