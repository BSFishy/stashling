class SaleAllocation < ApplicationRecord
  belongs_to :sale
  belongs_to :lot
end
