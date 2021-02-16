# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController

  # override the redirection and flash messages
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      flash[:notice] = "Password reset was sent to MailTrap Testing email testing service"
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash[:alert] = "Oh Snap! That one doesn't exists"
      respond_with({}, location: new_user_password_path)
    end
  end



  private

  # override the path
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end

end
