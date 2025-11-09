class Investment < ApplicationRecord
  validates :ticker, presence: true
  validates :amount, presence: true
end
