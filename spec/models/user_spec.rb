require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do

    it 'nicknameとemail、passwordとpassword_confirmationが存在すれば登録できる' do
      expect(@user).to be_valid
    end

    it 'nicknameが空では登録できない' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname can't be blank")
    end

    it 'emailが空では登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'passwordが空では登録できない' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'passwordとpassword_confirmationが不一致では登録できない' do
      @user.password = 'a12345'
      @user.password_confirmation = 'a12344'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'nicknameが6文字以上では登録できない' do
      @user.nickname = 'abcdefg'
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname is too long (maximum is 6 characters)")
    end

    it '重複したemailが存在する場合は登録できない' do
      @user.save
      another_user = FactoryBot.build(:user)
      another_user.email = @user.email
      another_user.valid?
      expect(another_user.errors.full_messages).to include('Email has already been taken')
    end

    it 'emailは@を含まないと登録できない' do
      @user.email = 'testmail'
      @user.valid?
      expect(@user.errors.full_messages).to include('Email is invalid')
    end

    it 'passwordが5文字以下では登録できない' do
      @user.password = 'a1234'#半角英数字込みで6文字以下で上書き
      @user.password_confirmation = 'a1234'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end

    it 'passwordが全角だと登録できない' do
      @user.password = 'ａ１２３４５' 
      @user.password_confirmation = 'ａ１２３４５'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password Please enter in half-width alphanumeric characters")
    end

    it 'passwordが全角英語のみだと登録できない' do
      @user.password = ' ａｂｃｄｅｆ' 
      @user.password_confirmation = ' ａｂｃｄｅｆ'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password Please enter in half-width alphanumeric characters")
    end

    it 'passwordに全角が入ってると登録できない' do
      @user.password = 'ａ12345' 
      @user.password_confirmation = 'ａ12345'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password Please enter in half-width alphanumeric characters")
    end

    it 'passwordが半角数字だけでは登録できない' do
      @user.password = '123456' 
      @user.password_confirmation = '123456'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password Please enter in half-width alphanumeric characters")
    end

    it 'passwordが半角英語だけでは登録できない' do
      @user.password = 'abcdef' 
      @user.password_confirmation = 'abcdef'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password Please enter in half-width alphanumeric characters")
    end

    it '確認passwordが不一致では登録できない' do
      @user.password = 'a12345'
      @user.password_confirmation = 'b12345'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'passwordが129文字以上では登録できない' do
      @user.password = Faker::Internet.password(min_length: 129, max_length: 150)
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is too long (maximum is 128 characters)")
    end

  end
end
