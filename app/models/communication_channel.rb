class CommunicationChannel < ApplicationRecord
  validates :path, :path_type, :workflow_state, :user_id, presence: true

  belongs_to :user
end
