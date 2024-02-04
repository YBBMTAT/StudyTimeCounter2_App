class UsersettingsController < ApplicationController
  before_action :set_usersetting, only: [:edit, :update]
  before_action :check_usersetting_owner, only: [:edit]
  

  def edit

  end

  def update
    if @usersetting.update(usersetting_params)
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
  @usersetting = Usersetting.find(params[:id])
end

def check_usersetting_owner
  unless current_user == @usersetting.user
    redirect_to root_path, alert: "他のユーザーの設定を編集することはできません。"
  end
end

  def usersetting_params
    converted_countdown_time = params[:usersetting][:countdown_time].to_i * 60
    params.require(:usersetting).permit(:configuration_state, :countdown_time).merge(countdown_time: converted_countdown_time)
  end
  
end
