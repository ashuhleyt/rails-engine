class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_item(string)
    where('name ILIKE ?', "%#{string}%").order('name').first
  end
end