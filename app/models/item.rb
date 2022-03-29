class Item < ApplicationRecord
  belongs_to :genre
  has_many :cart_items
  has_many :orders

  enum is_active: { on_sale: true, no_sale: false }
  attachment :image_id

  def add_tax_price
    (self.price * 1.1).round
  end

  validates :name, presence: true
  validates :genre_id, presence: true
  validates :image_id, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :is_active, presence: true
end
