class User < ApplicationRecord
  validates :sub, :name, presence: true
end
