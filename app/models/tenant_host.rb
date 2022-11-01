class TenantHost < ApplicationRecord
  validates :host, :tenant_id, presence: true
  validates :host, uniqueness: { scope: :tenant_id }

  class << self
    def for_host(host)
      return nil if host.blank?

      Rails.cache.fetch("tenants/#{host}") do
        find_by({ host: })
      end
    end
  end

  belongs_to :tenant
end
