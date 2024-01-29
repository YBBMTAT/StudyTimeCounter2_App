class TimersController < ApplicationController
  def index

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
    
    #日付毎の時間を格納するハッシュを初期化
    study_times = Hash.new(0)

    # 日付ごとの勉強時間を取得
    current_user.timers.where(created_at: start_date.beginning_of_day..end_date.end_of_day).each do |timer|
      study_times[timer.created_at.to_date] += timer.duration_seconds
    end

    # 期間内の各日付に対して勉強時間を合計
    dates_in_range.each do |date|
      # date日付の勉強時間を取得して合計に加算
      total_study_time = current_user.timers.where(created_at: date.beginning_of_day..date.end_of_day).sum(:duration_seconds)
      study_times[date] = total_study_time
    end

    # y軸最大値を計算する
    @max_study_time = ((study_times.values.max) + 1800) / 3600

    # 日ごとの時間を配列に追加
    @daily_study_times = dates_in_range.map do |date|
      [date.strftime("%m/%d"), ((study_times[date] || 0) / 3600.0).truncate(1)]
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
