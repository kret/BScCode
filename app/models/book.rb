class Book < ActiveRecord::Base
  attr_accessible :title, :original_title

  has_many :contributions,  :dependent => :destroy
  has_many :authors,        :through => :contributions,
                            :source => :person
end
