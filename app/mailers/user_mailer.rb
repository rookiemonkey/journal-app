class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'users/mailer' 

  def reset_password_instructions.html(user)
    mail(to: user.email, subject: 'Password Reset')
  end

end