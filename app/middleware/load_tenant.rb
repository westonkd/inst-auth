# frozen_string_literal: true

module Middleware
  class LoadTenant
    class TenantNotFound < StandardError; end

    TENANT_KEY = "inst-auth.current_tenant"

    def initialize(app)
      @app = app
    end

    def call(env)
      tenant = tenant_for(env)
      env[TENANT_KEY] = tenant

      Rails.logger.info("LOADED TENANT: #{tenant.name} (tenant.id = #{tenant.id})")

      @app.call(env)
    end

    def tenant_for(env)
      request_host = env['HTTP_HOST']

      tenant = TenantHost.for_host(request_host)&.tenant
      raise TenantNotFound, request_host unless request_host

      tenant
    end
  end
end
