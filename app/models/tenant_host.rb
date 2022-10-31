class TenantHost < ApplicationRecord
  validates :host, :tenant_id, presence: true
end
