class Tenant < ApplicationRecord
  validates :name, :regional_tenant_id, presence: true
end
