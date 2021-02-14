# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  # override the redirection instead of root path
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: home_dashboard_path
  end

end
