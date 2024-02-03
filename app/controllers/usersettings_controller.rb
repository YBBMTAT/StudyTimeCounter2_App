class UsersettingsController < ApplicationController
  before_action :set_usersetting, only: [:edit, :update]

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
    @usersetting = current_user.usersetting || current_user.build_usersetting
  end

  def usersetting_params
    params.require(:usersetting).permit(:configuration_state, :countdown_time)
  end
  
end
