require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    context '@userが保存できる場合' do
      it 'nameとemail、passwordとpassword_confirmationが存在すれば登録できること' do
        expect(@user).to be_valid
      end

      it 'passwordが6文字以上であれば登録できること' do
        @user.password = 'a12345'
        @user.password_confirmation = 'a12345'
        expect(@user).to be_valid
      end
    end

    context '@userが保存できない場合' do
      it 'nicknameが空では登録できないこと' do
        @user.nickname = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'emailが空では登録できないこと' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end

      it '重複したemailが存在する場合登録できないこと' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end

      it 'passwordが空では登録できないこと' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが存在してもpassword_confirmationが空では登録できないこと' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it 'passwordが5文字以下であれば登録できないこと' do
        @user.password = 'a1234'
        @user.password_confirmation = 'a1234'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end

      it 'passwordが英数字混合でないと登録できないこと' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password Include both letters and numbers')
      end
    end
  end
end
