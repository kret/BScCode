class Contribution < ActiveRecord::Base
  validates :book,    :presence => true
  validates :person,  :presence => true

  belongs_to :book
  belongs_to :person
end
