class UsersettingsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_usersetting, only: [:edit, :update]
  before_action :check_usersetting_owner, only: [:edit]
  

  def edit

  end

  def update
    #更新対象を取得
   @usersetting = Usersetting.find(params[:id])
   #取得した分数を秒に変換(モデル側へ)
   countdown_time_minutes = params[:usersetting][:countdown_time].to_f
   countdown_time_seconds = @usersetting.convert_countdown_time(countdown_time_minutes)

    if @usersetting.update(usersetting_params.merge(countdown_time: countdown_time_seconds))
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def countdown_setting
    @usersetting = current_user.usersetting
    render json: { 
      configuration_state: @usersetting.configuration_state,
      countdown_time: @usersetting.countdown_time
    }
  end

private

def set_usersetting
  @usersetting = Usersetting.find_by(id: params[:id])
  redirect_to root_path unless @usersetting
end

def check_usersetting_owner
  return unless @usersetting
  redirect_to root_path unless current_user == @usersetting.user
end

def usersetting_params
  params.require(:usersetting).permit(:configuration_state, :countdown_time)
end
  
end
