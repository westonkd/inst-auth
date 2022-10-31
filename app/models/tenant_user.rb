class TenantUser < ApplicationRecord
  validates :role, :user_id, :tenant_id, presence: true
end
