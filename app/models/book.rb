class Book < ActiveRecord::Base
  attr_accessible :title, :original_title, :au_ids
  attr_reader :au_ids

  has_many :contributions,  :dependent => :destroy
  has_many :authors,        :through => :contributions,
                            :source => :person
  has_many :preferences,    :dependent => :destroy

  validates :title,   :presence => { :message => I18n.t('book.validation.title.blank') }
  validates :au_ids,  :presence => { :message => I18n.t('book.validation.au_ids.blank') }
  validate :valid_au_ids

  after_validation :make_builds

  def au_ids=(ids)
    @au_ids = ids.collect(&:to_i).uniq unless ids.blank?
  end

  protected

    def valid_au_ids
      begin
        Person.find au_ids if au_ids
      rescue ActiveRecord::RecordNotFound
        errors[:au_ids] << I18n.translate('book.validation.au_ids.record_not_valid')
      end
    end

    def make_builds
      if au_ids && errors[:au_ids].empty?
        au_ids.each do |i|
          contributions.build({ :person => Person.find(i), :book => self })
        end
      end
    end
end
