class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]

  def show; end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @profile.update!(profile_params)
      @profile.user.update!(user_params)
    end
  
    flash[:success] = 'プロフィールを更新しました'
    redirect_to profile_path
  rescue ActiveRecord::RecordInvalid
    flash.now['danger'] = 'プロフィールが更新できませんでした'
    render :edit, status: :unprocessable_entity
  end

  private

  def set_profile
    @profile = Profile.find_by(user_id: current_user.id)
  end

  def profile_params
    params.require(:profile).permit(:profile_image_url)
  end

  def user_params
    params.require(:profile).permit(:name, :email)
  end
end
