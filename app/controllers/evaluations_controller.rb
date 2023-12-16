class EvaluationsController < ApplicationController
  before_action :set_song
  before_action :require_login
  before_action :set_evaluation, only: [:update, :destroy]

  def create
    existing_evaluation = @song.evaluations.find_by(user: current_user)
    existing_evaluation.destroy if existing_evaluation
    @evaluation = @song.evaluations.build(evaluation_params)
    @evaluation.user = current_user
    
    if @evaluation.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @song }
      end
    else
      flash[:danger] = '評価はログインしているユーザのみ行えます。ログインしているか確認してください。'
      redirect_to @song, status: :unprocessable_entity
    end
  end

  def update
    if @evaluation.evaluation_point != evaluation_params[:evaluation_point]
      @evaluation.update(evaluation_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @song }
      end
    else
      redirect_to @song
    end
  end

  def destroy
    @evaluation.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @song, status: :see_other }
    end
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end

  def set_evaluation
    @evaluation = @song.evaluations.find_by(user: current_user)
  end

  def evaluation_params
    params.require(:evaluation).permit(:evaluation_point).transform_values(&:to_i)
  end
end
