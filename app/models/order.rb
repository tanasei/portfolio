class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details

  enum order_status: {
    waiting_deposit: 0,
    payment_confirmation: 1,
    production: 2,
    preparing_delivery: 3,
    sent: 4
  }

  enum payment_method: { credit_card: 0, transfer: 1 }

  validates :address, :postal_code,
            :name, :status, :payment_method,  presence: true
end
