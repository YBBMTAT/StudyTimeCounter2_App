class TimersController < ApplicationController
  def index
  end

  def save
    # 受け取ったデータを処理
    duration_seconds = params[:duration_seconds]
    puts "Received duration_seconds: #{duration_seconds}"
    # データベースに保存する処理を追加
    Timer.create(user_id: current_user.id, duration_seconds: duration_seconds)

    render json: { status: 'success' }
  end
end
