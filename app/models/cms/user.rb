class Cms::User
  include Mongoid::Document

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
end
