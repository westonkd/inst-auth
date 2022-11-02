class User < ApplicationRecord
  validates :sub, :name, presence: true
  has_many :communication_channels
end
