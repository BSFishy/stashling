class Adjustment < ApplicationRecord
  belongs_to :lot

  enum adjustment_type: {
    dividend: 0,
    split: 1,
    fee: 2,
    other: 3
  }
end
