class PasswordResetsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    flash[:success] = 'パスワードリセット手順を送信しました'
    redirect_to new_user_session_path
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      flash[:success] = 'パスワードを変更しました'
      redirect_to new_user_session_path
    else
      flash.now[:danger] = "パスワードが変更できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end
end
