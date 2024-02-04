class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, presence: true, length: { minimum: 6 }, format: { with: /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i, message: "は6文字以上の半角英数字で入力してください。"}
  validates :nickname, presence: true, length: { maximum: 6 }


  has_many :timers
  has_one :usersetting

  after_create :create_default_usersetting

  private
  def create_default_usersetting
    # 新しい Usersetting レコードを作成し、関連付けられた User レコードの ID を user_id に設定する
    build_usersetting(configuration_state: true, countdown_time: 300, user_id: self.id).save
  end
end
