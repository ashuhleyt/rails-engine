class Merchant < ApplicationRecord
  has_many :items 
  validates :name, presence: true

  def self.search_for_all(string)
    where('name ILIKE ?', "%#{string}%").order('name')
  end
end 