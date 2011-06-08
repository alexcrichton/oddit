class Authentication
  include Mongoid::Document

  field :provider
  field :uid

  belongs_to :user

  validates_presence_of :provider, :uid, :user
  validates_uniqueness_of :uid, :scope => :provider
end
