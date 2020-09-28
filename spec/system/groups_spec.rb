require 'rails_helper'

RSpec.describe 'グループ作成機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.build(:group)
  end

  context 'グループ作成に成功したとき' do
    it 'フォームの送信に成功すると、トップページに遷移して、新たにグループが作成されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にグループ作成フォームが存在しないことを確認する
      expect(page).to have_no_css('.top-form-create')
      # 「グループを作成」をクリックする
      find('.open-create-form').click
      # 画面上にグループ作成フォームが現れることを確認する
      expect(page).to have_css('.top-form-create')
      # 値をフォームに入力する
      fill_in 'group_name', with: @group.name
      # 送信すると、値がテーブルに保存されていることを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Group.count }.by(1)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # トップページに新たにグループが3箇所に作成されていることを確認する
      expect(page).to have_content(@group.name, count: 3)
    end
  end

  context 'グループ作成に失敗したとき' do
    it '空の値を入力してフォームを送信すると、indexテンプレートがrenderされ、エラーメッセージが表示されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にグループ作成フォームが存在しないことを確認する
      expect(page).to have_no_css('.top-form-create')
      # 「グループを作成」をクリックする
      find('.open-create-form').click
      # 画面上にグループ作成フォームが現れることを確認する
      expect(page).to have_css('.top-form-create')
      # フォームに空の値を入力する
      fill_in 'group_name', with: ''
      # フォームを送信すると、テーブルにレコードが保存されていないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { Group.count }.by(0)
      # indexテンプレートがrenderされていることを確認する
      expect(current_path).to eq groups_path
      # グループが作成されていないことを確認する
      expect(page).to have_no_css('.group-panel')
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content("グループ名を入力してください")
    end
  end
end

RSpec.describe 'グループ編集機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @groups = FactoryBot.create_list(:group, 2, user_id: @user.id)
    @group = FactoryBot.build(:group)
  end

  context 'グループ編集に成功したとき' do
    it 'フォームを送信してDBの更新に成功すると、グループ名が更新後のものに変更されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にあらかじめ作成したグループが2種類(各3つ)存在することを確認する
      @groups.each do |group|
        expect(page).to have_content(group.name, count: 3)
      end
      # 画面上にグループ編集フォームが存在しないことを確認する
      expect(page).to have_no_css('.top-form-edit')
      # グループパネル右上のペンのアイコンをクリックする
      all('.group-panel__edit.js-0')[0].click
      # 画面上にグループ編集フォームが存在することを確認する
      expect(page).to have_css('.top-form-edit')
      # フォームのテキストエリアに既にグループ名が入力されていることを確認する
      expect(
        find('.top-form-edit__input').text
      ).to eq @groups[0].name
      # 編集後のグループ名を入力する
      fill_in 'group_name', with: @group.name
      # フォームを送信する
      find('input[name="commit"]').click
      # 画面上に編集後のグループ名が3つ存在することを確認する
      expect(page).to have_content(@group.name, count: 3)
      # 画面上にグループ編集フォームが存在しないことを確認する
      expect(page).to have_no_css('.top-form-edit')
    end
  end

  context 'グループ編集に失敗したとき' do
    it '空の値を入力してフォームを送信すると, グループ名が更新されず、エラーメッセージが表示されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にあらかじめ作成したグループが2種類(各3つ)存在することを確認する
      @groups.each do |group|
        expect(page).to have_content(group.name, count: 3)
      end
      # 画面上にグループ編集フォームが存在しないことを確認する
      expect(page).to have_no_css('.top-form-edit')
      # グループパネル右上のペンのアイコンをクリックする
      all('.group-panel__edit.js-0')[0].click
      # 画面上にグループ編集フォームが存在することを確認する
      expect(page).to have_css('.top-form-edit')
      # フォームのテキストエリアに既にグループ名が入力されていることを確認する
      expect(
        find('.top-form-edit__input').text
      ).to eq @groups[0].name
      # 空の値を入力する
      fill_in 'group_name', with: ''
      # フォームを送信する
      find('input[name="commit"]').click
      # 画面上にalertダイアログが表示されていることを確認して、okを押す
      expect(page.accept_alert).to eq "グループ名を入力してください"
      # 画面上にグループ編集フォームが存在することを確認する
      expect(page).to have_css('.top-form-edit')
      # ×ボタンをクリックする
      find('.top-form-edit__close-btn.js-0').click
      # 画面上にグループ編集フォームが存在しないことを確認する
      expect(page).to have_no_css('.top-form-edit')
      # 画面上に編集前のグループ名が3つ存在することを確認する
      expect(page).to have_content(@groups[0].name, count: 3)
    end
  end
end

RSpec.describe 'グループ削除機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
  end

  it 'グループ削除ボタンを押して、確認ダイアログのokを押すと、グループが削除されること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 画面上にあらかじめ作成したグループが3つ存在することを確認する
    expect(page).to have_content(@group.name, count: 3)
    # 問題管理ページへのリンクが存在することを確認する
    expect(page).to have_link @group.name, href: group_question_answers_path(@group)
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 画面上にグループを削除のリンクが存在することを確認する
    expect(page).to have_link 'グループを削除', href: group_path(@group)
    # グループ削除のリンクをクリックする
    find('.destroy-group').click
    # グループ削除の確認ダイアログが表示されることを確認してokを押すと、レコードの数が1減ることを確認する
    expect do
      expect(page.accept_confirm).to eq "グループ内の問題も全て削除されます。\n本当に削除しますか？"
      sleep 0.1
    end.to change { Group.count }.by(-1)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 削除したグループが存在しないことを確認する
    expect(page).to have_no_content(@group.name)
  end

  it 'グループ削除ボタンを押して、確認ダイアログのキャンセルを押すと、グループが削除されないこと' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 画面上にあらかじめ作成したグループが3つ存在することを確認する
    expect(page).to have_content(@group.name, count: 3)
    # 問題管理ページへのリンクが存在することを確認する
    expect(page).to have_link @group.name, href: group_question_answers_path(@group)
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 画面上にグループを削除のリンクが存在することを確認する
    expect(page).to have_link 'グループを削除', href: group_path(@group)
    # グループ削除のリンクをクリックする
    find('.destroy-group').click
    # グループ削除の確認ダイアログが表示されることを確認してキャンセルを押すと、レコードの数が変わらないことを確認する
    expect do
      expect(page.dismiss_confirm).to eq "グループ内の問題も全て削除されます。\n本当に削除しますか？"
      sleep 0.1
    end.to change { Group.count }.by(0)
    # 現在のページが問題管理ページのままであることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # トップページに遷移する
    visit root_path
    # 削除ボタンを押した後確認ダイアログでキャンセルしたグループが3つ存在することを確認する
    expect(page).to have_content(@group.name, count: 3)
  end
end
