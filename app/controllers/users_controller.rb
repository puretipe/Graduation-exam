class UsersController < ApplicationController
  before_action :require_login, only: [:following_artists]

  def new
    @user = User.new
  end

  def create        
    @user = User.new(user_params)
    if @user.save
      flash[:success] = '登録が完了しました'
      redirect_to new_user_session_path
    else
      flash.now[:danger] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def following_artists
    @user = User.find(params[:id])
    @artists = @user.following.where(role: :artist).page(params[:page])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
