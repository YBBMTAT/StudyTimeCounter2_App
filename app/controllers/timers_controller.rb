class TimersController < ApplicationController
  def index
    @timers = Timer.all
  end

  def show
    # 累積時間の取得
    @cumulative_time = format_duration(current_user.timers.sum(:duration_seconds))
     weekly_timers = current_user.timers.where(created_at: 1.week.ago..Time.now)
    @weekly_time = weekly_timers.present? ? format_duration(weekly_timers.sum(:duration_seconds)) : "No data"
     monthly_timers = current_user.timers.where(created_at: 1.month.ago..Time.now)
    @month_time = monthly_timers.present? ? format_duration(monthly_timers.sum(:duration_seconds)) : "No data"

    #グラフ用のデータ取得
    #今日から１週間前までの日を取得
    start_date = Date.today - 1.week
    end_date = Date.today
    dates_in_range = (start_date..end_date).to_a
    
    #日付に対してDBから該当日付を取得
    study_times = {}
    dates_in_range.each do |date|
      study_times[date] = current_user.timers.where(created_at: date.beginning_of_day..date.end_of_day).sum(:duration_seconds)
    end

    #日ごとの時間を配列に追加
    @daily_study_times = dates_in_range.map do |date|
      [date.strftime("%m/%d"), study_times[date] || 0]
    end

  end

  def save
    # 受け取ったデータを処理
    duration_seconds = params[:duration_seconds]
    puts "Received duration_seconds: #{duration_seconds}"
    # データベースに保存する処理を追加
    Timer.create(user_id: current_user.id, duration_seconds: duration_seconds)

    render json: { status: 'success' }
  end

  private

  def format_duration(seconds)
    Time.at(seconds).utc.strftime("%H時間%M分%S秒")
  end

end
