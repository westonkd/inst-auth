class Tenant < ApplicationRecord
  validates :name, presence: true

  class << self
    def regional_default
      Rails.cache.fetch('tenants/regional_default') do
        find_by(regional_tenant: nil)
      end
    end
  end

  belongs_to :regional_tenant, class_name: 'Tenant', optional: true

  has_many :connections
  has_many :tenant_hosts
  has_many :users
  has_many :applications
end
