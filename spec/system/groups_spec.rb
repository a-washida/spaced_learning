require 'rails_helper'

RSpec.describe "グループ作成機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.build(:group)
  end

  context 'グループ作成に成功したとき' do
    it 'フォームの送信に成功すると、トップページに遷移して、新たにグループが作成されている' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にグループ作成フォームが存在しないことを確認する
      expect(page).to have_no_css(".top-form-create")
      # 「グループを作成」をクリックする
      find(".open-create-form").click
      # 画面上にグループ作成フォームが現れることを確認する
      expect(page).to have_css(".top-form-create")
      # 値をフォームに入力する
      fill_in 'group_name', with: @group.name
      # 送信すると、値がテーブルに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Group.count }.by(1)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # トップページに新たにグループが3箇所に作成されていることを確認する
      expect(page).to have_content(@group.name, count: 3)
    end
  end

  context 'グループ作成に失敗したとき' do
    it '値を入力せずにフォームを送信すると、indexテンプレートがrenderされ、エラーメッセージが表示されている' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にグループ作成フォームが存在しないことを確認する
      expect(page).to have_no_css(".top-form-create")
      # 「グループを作成」をクリックする
      find(".open-create-form").click
      # 画面上にグループ作成フォームが現れることを確認する
      expect(page).to have_css(".top-form-create")
      # 値を入力せずにフォームを送信すると、テーブルにレコードが保存されていないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Group.count }.by(0)
      # indexテンプレートがrenderされていることを確認する
      expect(current_path).to eq groups_path
      # グループが作成されていないことを確認する
      expect(page).to have_no_css(".group-panel")
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content("Name can't be blank")      
    end
  end
end

