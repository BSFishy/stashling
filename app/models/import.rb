class Import < ApplicationRecord
  enum status: {
    pending: 0,
    parsing: 1,
    validating: 2,
    committed: 3,
    failed: 4
  }
end
