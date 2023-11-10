class EvaluationsController < ApplicationController
  before_action :set_song
  before_action :require_login
  before_action :set_evaluation, only: [:update, :destroy]

  def create
    # 既存の評価を探す
    existing_evaluation = @song.evaluations.find_by(user: current_user)
    
    # 既存の評価があれば削除する
    existing_evaluation.destroy if existing_evaluation

    # 新しい評価を作成する
    @evaluation = @song.evaluations.build(evaluation_params)
    @evaluation.user = current_user
    
    if @evaluation.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @song }
      end
    else
      # 評価の保存に失敗した場合の処理
      flash[:danger] = '評価はログインしているユーザのみ行えます。ログインしているか確認してください。'
      redirect_to @song, status: :unprocessable_entity
    end
  end

  def update
    # 評価が異なれば更新
    if @evaluation.evaluation_point != evaluation_params[:evaluation_point]
      @evaluation.update(evaluation_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @song }
      end
    else
      # 評価が同じなら何もせずに曲のページにリダイレクト
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
