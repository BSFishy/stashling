class Sale < ApplicationRecord
  belongs_to :asset
  belongs_to :account
end
