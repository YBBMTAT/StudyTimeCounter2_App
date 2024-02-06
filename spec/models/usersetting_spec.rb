require 'rails_helper'

RSpec.describe Usersetting, type: :model do
  describe '休憩時間が設定' do

    it 'countdown_timeに半角数値入力であれば設定できる' do
      countdown_time = Usersetting.new(countdown_time: '10')
    end

    it 'countdown_timeに半角数値入力で小数点ありでも設定できる' do
      countdown_time = Usersetting.new(countdown_time: '10.5')
    end

    it 'countdown_timeが空では設定出来ない' do
      countdown_time = Usersetting.new(countdown_time: '')
      countdown_time.valid?
      expect(countdown_time.errors.full_messages).to include("User must exist", "Countdown time can't be blank", "Countdown time is not a number")
    end

    it 'countdown_timeが数値以外では設定出来ない' do
      countdown_time = Usersetting.new(countdown_time: 'いち')
      countdown_time.valid?
      expect(countdown_time.errors.full_messages).to include("User must exist", "Countdown time is not a number")
    end

    it 'countdown_timeがマイナス数値では設定出来ない' do
      countdown_time = Usersetting.new(countdown_time: '-10')
      countdown_time.valid?
      expect(countdown_time.errors.full_messages).to include("User must exist", "Countdown time must be greater than 0")
    end

    it 'countdown_timeが0では設定出来ない' do
      countdown_time = Usersetting.new(countdown_time: '0')
      countdown_time.valid?
      expect(countdown_time.errors.full_messages).to include("User must exist", "Countdown time must be greater than 0")
    end

    it 'ユーザーが紐付いていなければ投稿できない' do
      usersetting = Usersetting.new(user: nil)
      usersetting.valid?
      expect(usersetting.errors.full_messages).to include('User must exist')
    end
  end
end
