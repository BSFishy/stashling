class Lot < ApplicationRecord
  belongs_to :asset
  belongs_to :account
end
