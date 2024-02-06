class Usersetting < ApplicationRecord
  
  def convert_countdown_time(minutes)
    minutes * 60.round(1)
  end
  
  belongs_to :user

  validates :countdown_time, presence: true, numericality: { greater_than: 0 }
end
