class ApplicationController < ActionController::Base
  private

  def not_authenticated
    flash[:danger] = "ログインが必要です。"
    redirect_to new_user_session_path
  end
end
