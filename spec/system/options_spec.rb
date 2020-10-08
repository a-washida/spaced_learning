require 'rails_helper'

RSpec.describe "復習タイミング設定の編集機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context '設定の編集に成功したとき' do
    it '設定の編集に成功すると、トップページにリダイレクトされnoticeが表示されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 設定の編集ページに遷移する
      visit edit_option_path(@user.option)
      # Optionsテーブルに保存されている値が、フォームに既に入力された状態になっていることを確認する
      expect(
        find('#option_interval_of_ml1').value
      ).to eq "#{@user.option.interval_of_ml1}"
      expect(
        find('#option_interval_of_ml2').value
      ).to eq "#{@user.option.interval_of_ml2}"
      expect(
        find('#option_interval_of_ml3').value
      ).to eq "#{@user.option.interval_of_ml3}"
      expect(
        find('#option_upper_limit_of_ml1').value
      ).to eq "#{@user.option.upper_limit_of_ml1}"
      expect(
        find('#option_upper_limit_of_ml2').value
      ).to eq "#{@user.option.upper_limit_of_ml2}"
      expect(
        find('#option_easiness_factor').value
      ).to eq "#{@user.option.easiness_factor}"
      # フォームに編集後の値を入力する
      fill_in 'option_interval_of_ml1', with: 2
      fill_in 'option_interval_of_ml2', with: 3
      fill_in 'option_interval_of_ml3', with: 5
      fill_in 'option_interval_of_ml4', with: 7
      fill_in 'option_upper_limit_of_ml1', with: 4
      fill_in 'option_upper_limit_of_ml2', with: 8
      fill_in 'option_easiness_factor', with: 240
      # 更新ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # notice「設定を変更しました」が画面上に表示されていることを確認する
      expect(page).to have_content('設定を変更しました')
    end
  end

  context '設定の編集に失敗したとき' do
    it '不正な値を入力してフォームを送信すると、設定の編集ページがrenderされエラーメッセージが表示されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 設定の編集ページに遷移する
      visit edit_option_path(@user.option)
      # フォームに不正な値を入力する
      fill_in 'option_interval_of_ml1', with: 0
      # 更新ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # 設定の編集ページがrenderされていることを確認する
      expect(current_path).to eq "/options/#{@user.option.id}"
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('記憶度1の場合のインターバルは0より大きい値にしてください')
    end
  end
end
