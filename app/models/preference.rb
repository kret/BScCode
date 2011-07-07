class Preference < ActiveRecord::Base
  attr_accessible :likes, :possesses, :wants_to_read, :wants_to_give_away

  belongs_to :user
  belongs_to :book

  validates :user,                :presence => true
  validates :book,                :presence => true
  validates :likes,               :in => [true, false], :allow_nil => true
  validates :possesses,           :in => [true, false], :allow_nil => true
  validates :wants_to_read,       :in => [true, false], :allow_nil => true
  validates :wants_to_give_away,  :in => [true, false], :allow_nil => true

  scope :find_for_book_and_user, lambda { |book, user| where(:user_id => user, :book_id => book) }
end
