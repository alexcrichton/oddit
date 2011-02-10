class User
  include Mongoid::Document

  field :andrew_id
  field :email

  has_and_belongs_to_many :majors
  embeds_many :semesters

  validates_presence_of :andrew_id, :email
  validates_uniqueness_of :andrew_id, :email

  attr_accessible :andrew_id, :email
end
