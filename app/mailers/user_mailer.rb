class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find(user.id)
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email,
         from: 'puretipe1104@gmail.com',
         subject: "パスワードリセット")
  end
end
