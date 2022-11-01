class ApplicationController < ActionController::Base
  before_action :foobar

  def foobar
    puts current_tenant
  end

  protected

  def current_tenant
    @current_tenant ||= request.env[Middleware::LoadTenant::TENANT_KEY]
  end
end
