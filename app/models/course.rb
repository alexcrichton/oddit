require 'open-uri'

class Course
  include Mongoid::Document

  field :number
  field :name
  field :units, :type => Integer

  validates_presence_of :number, :name, :units
  validates_format_of :number, :with => /^\d{2}-\d{3}$/
  validates_uniqueness_of :number

  attr_accessible :number, :name, :units

  scope :search, lambda{ |q| any_of({:name => /#{q}/i}, {:number => /^#{q}/i}) }

  def self.import_from_url url
    n = Nokogiri::HTML(open(url).read)

    n.css('tr').each{ |row|
      next unless row.children[0].text.match(/\d{5}/)

      attrs = {
        :number => row.children[0].text.gsub(/^(\d{2})/, '\1-'),
        :name   => row.children[1].text,
        :units  => row.children[2].text.to_i
      }

      c = Course.where(:number => attrs[:number]).first || Course.new

      c.attributes = attrs

      c.save!
    }

    true
  end

  def pretty_name
    name + " (#{number})"
  end
end
