class Asset < ApplicationRecord
  enum :security_type, {
    equity: 0,
    etf: 1,
    mutual_fund: 2,
    bond: 3,
    crypto: 4,
    other: 5
  }
end
