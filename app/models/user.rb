class User < ApplicationRecord
  validates :sub, :name, :tenant_id, presence: true
  has_many :communication_channels
  belongs_to :tenant
end
