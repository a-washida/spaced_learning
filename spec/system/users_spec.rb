require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # 新規登録ページに移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: @user.nickname
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      # 新規登録ボタンを押すとUserモデルとOptionモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count && Option.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # ユーザー名のボタンや、ログアウトボタンが表示されていることを確認する
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_nickname', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      # 新規登録ボタンを押してもUserモデルとOptionモデルのカウントは上がらないことを確認する
      expect do
        find('input[name="commit"]')
      end.to change { User.count && Option.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq new_user_registration_path
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  it 'ログインしていない状態でトップページにアクセスすると、ログインページに遷移する' do
    # トップページへ遷移する
    visit root_path
    # ログインページへ遷移することを確認する
    expect(current_path).to eq new_user_session_path
  end

  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ユーザー名のボタンや、ログアウトボタンが表示されていることを確認する
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_css('.login')
      expect(page).to have_no_content('新規登録')
      # ログイン成功のnotice(ログインしました。)が表示されていることを確認する
      expect(page).to have_content('ログインしました。')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # エラーメッセージ(Eメールまたはパスワードが違います。)が表示されることを確認する
      expect(page).to have_content('Eメールまたはパスワードが違います。')
    end
  end
end

RSpec.describe 'ユーザー情報編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.build(:user)
  end

  context 'ユーザー情報編集ができるとき' do
    it '正しい情報を入力すればユーザー情報を編集できてトップページにリダイレクトすること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にログインしているユーザー名が表示されており、ユーザー情報編集ページへのリンクとなっていることを確認する
      expect(page).to have_link @user.nickname, href: edit_user_registration_path
      # ユーザー名のリンクをクリックする
      click_link(@user.nickname)
      # ユーザー情報編集ページに遷移していることを確認する
      expect(current_path).to eq edit_user_registration_path
      # フォームに既にニックネームとメールアドレスが記入されていることを確認する
      expect(
        find('#user_nickname').value
      ).to eq @user.nickname
      expect(
        find('#user_email').value
      ).to eq @user.email
      # フォームに新しいニックネームとメールアドレスを記入する
      fill_in 'ニックネーム', with: @another_user.nickname
      fill_in 'メールアドレス', with: @another_user.email
      # ユーザー編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 「アカウント情報を変更しました。」のnoticeが表示されていることを確認する
      expect(page).to have_content('アカウント情報を変更しました。')
      # 画面上に表示されているユーザー名が変更されていることを確認する
      expect(page).to have_content(@another_user.nickname)
    end
  end

  context 'ユーザー情報編集に失敗するとき' do
    it '不正なユーザー情報を入力すると、ユーザー情報編集に失敗しエラーメッセージが表示されること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にログインしているユーザー名が表示されており、ユーザー情報編集ページへのリンクとなっていることを確認する
      expect(page).to have_link @user.nickname, href: edit_user_registration_path
      # ユーザー名のリンクをクリックする
      click_link(@user.nickname)
      # ユーザー情報編集ページに遷移していることを確認する
      expect(current_path).to eq edit_user_registration_path
      # フォームに既にニックネームとメールアドレスが記入されていることを確認する
      expect(
        find('#user_nickname').value
      ).to eq @user.nickname
      expect(
        find('#user_email').value
      ).to eq @user.email
      # フォームに空のニックネームとメールアドレスを記入する
      fill_in 'ニックネーム', with: ''
      fill_in 'メールアドレス', with: ''
      # ユーザー編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # ユーザー情報編集ページへ戻されることを確認する
      expect(current_path).to eq '/users'
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('ニックネームを入力してください')
      expect(page).to have_content('Eメールを入力してください')
    end

    it 'テストユーザーはユーザー情報編集できないこと' do
      test_user = FactoryBot.create(:user, nickname: 'テスト')
      # サインインする
      login(test_user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # ユーザー名のリンクをクリックする
      click_link(test_user.nickname)
      # ユーザー情報編集ページに遷移していることを確認する
      expect(current_path).to eq edit_user_registration_path
      # フォームに既にニックネームとメールアドレスが記入されていることを確認する
      expect(
        find('#user_nickname').value
      ).to eq test_user.nickname
      expect(
        find('#user_email').value
      ).to eq test_user.email
      # フォームに新しいニックネームとメールアドレスを記入する
      fill_in 'ニックネーム', with: @another_user.nickname
      fill_in 'メールアドレス', with: @another_user.email
      # ユーザー編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # ユーザー情報編集ページへ戻されることを確認する
      expect(current_path).to eq '/users'
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('テストユーザーの情報は編集できません')
    end
  end
end

RSpec.describe 'ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  it 'ログアウトボタンを押すと、ログアウトができる' do
    # ログインする
    login(@user)
    # ログアウトボタンが表示されている
    expect(page).to have_content('ログアウト')
    # ログアウトボタンをクリックする
    click_on('ログアウト')
    # ログインページに遷移することを確認する
    expect(current_path).to eq new_user_session_path
  end
end
