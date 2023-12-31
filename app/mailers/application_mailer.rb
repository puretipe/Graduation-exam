class ApplicationMailer < ActionMailer::Base
  def reset_password_email(user)
    @user = user
    mail(to: user.email, from: 'puretipe1104@gmail.com', subject: 'パスワードリセットの手順')
  end
end
