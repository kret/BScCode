class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  has_many :contributions,  :dependent => :destroy
  has_many :books,          :through => :contributions
end
