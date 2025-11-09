class AuditEvent < ApplicationRecord
  enum :action, {
    created: 0,
    updated: 1,
    deleted: 2,
    restored: 3
  }
end
