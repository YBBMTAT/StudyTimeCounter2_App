class Usersetting < ApplicationRecord
  
  def countdown_time_in_seconds
    countdown_time * 60
  end
  
  belongs_to :user

  validates :countdown_time, presence: true, numericality: { greater_than: 0 }
end
