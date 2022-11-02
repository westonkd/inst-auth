# frozen_string_literal: true

class Application < ApplicationRecord
  TYPES = OpenStruct.new(
    machine_to_machine: 'machine_to_machine',
    native: 'native',
    single_page_application: 'single_page_application',
    web_application: 'web_application'
  )

  RESPONSE_TYPES = OpenStruct.new(code: 'code')

  VALID_RESPONSE_TYPES = {
    TYPES.web_application => [RESPONSE_TYPES.code]
  }.freeze

  belongs_to :tenant

  # TODO: Encrypt secrets:
  # client_secret :ssn, key: ENV['COLUMN_ENCRYPTION_KEY']
  validates :name, :description, :client_id, :client_secret, :redirect_uris, :application_type, presence: true
  validates :client_id, uniqueness: true

  before_validation :populate_defaults, on: :create

  def supports_response_type?(response_type)
    VALID_RESPONSE_TYPES[application_type].include? response_type
  end

  private

  def populate_defaults
    self.client_id ||= SecureRandom.uuid
    self.client_secret ||= SecureRandom.base64(64)
  end
end
