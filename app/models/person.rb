class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  has_many :contributions,  :dependent => :destroy
  has_many :books,          :through => :contributions

  validates :first_name,  :presence => true
  validates :last_name,   :presence => true

  scope :full_name_containing, lambda { |terms, is_full_search = false|
    where(terms.collect { |t| "LOWER(first_name) like '#{(is_full_search ? '%' : '')}#{t}%' OR LOWER(last_name) like '#{(is_full_search ? '%' : '')}#{t}%'" }.join " OR ")
  }

  def display_name
    "#{self.first_name} #{self.last_name}"
  end
end
