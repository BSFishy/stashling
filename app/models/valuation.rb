class Valuation < ApplicationRecord
  belongs_to :asset
  belongs_to :lot
end
