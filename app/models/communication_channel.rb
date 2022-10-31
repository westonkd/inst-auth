class CommunicationChannel < ApplicationRecord
  validates :path, :path_type, :workflow_state, :user_id, presence: true
end
