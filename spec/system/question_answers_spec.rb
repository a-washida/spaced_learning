require 'rails_helper'

RSpec.describe "問題作成機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
    @question_answer = FactoryBot.build(:question_answer, user_id: @user.id, group_id: @group.id)
  end


  context '問題作成に成功したとき' do
    it '問題の作成に成功すると、問題作成ページが再度表示され、noticeが表示されていること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 画面上にあらかじめ作成したグループが3つ存在することを確認する
      expect(page).to have_content(@group.name, count: 3)
      # 問題作成ページへのリンクが存在することを確認する
      expect(page).to have_link @group.name, href: new_group_question_answer_path(@group)
      # 問題作成ページへのリンクをクリックする
      find('.group-panel.js-1').click
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # 「文字サイズを変更」のプルダウンで1が選択されていることを確認する(問題プレビューと解答プレビュー二箇所)
      expect(page).to have_select('question_answer_question_option_attributes_font_size_id', selected: '1')
      expect(page).to have_select('question_answer_answer_option_attributes_font_size_id', selected: '1')
      # 「画像サイズを変更」のプルダウンで1.0が選択されていることを確認する(問題プレビューと解答プレビュー二箇所)
      expect(page).to have_select('question_answer_question_option_attributes_image_size_id', selected: '1.0')
      expect(page).to have_select('question_answer_answer_option_attributes_image_size_id', selected: '1.0')
      # フォームの問題エリアと解答エリアに問題と解答を入力する
      fill_in 'question_answer_question', with: @question_answer.question
      fill_in 'question_answer_answer', with: @question_answer.answer
      # 入力内容がプレビューエリアに反映されることを確認する
      expect(
        find("#question-preview__textarea").text
      ).to eq @question_answer.question
      expect(
        find("#answer-preview__textarea").text
      ).to eq @question_answer.answer
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 問題と解答の画像選択フォームに画像を添付する
      attach_file('question_answer[question_option_attributes][image]', image_path, make_visible: true)
      attach_file('question_answer[answer_option_attributes][image]', image_path, make_visible: true)
      # 添付した画像がプレビューエリアに反映されることを確認する
      expect(page).to have_css(".img-preview-question")
      expect(page).to have_css(".img-preview-answer")
      #「文字サイズを変更」のプルダウンで0.8を選択する(問題プレビューと解答プレビュー二箇所)
      select('0.8', from: 'question_answer[question_option_attributes][font_size_id]')
      select('0.8', from: 'question_answer[answer_option_attributes][font_size_id]')
      # 文字サイズがが0.8remになっていることを確認する
      expect(page).to have_selector("#question-preview__textarea[style='font-size: 0.8rem;']")
      expect(page).to have_selector("#answer-preview__textarea[style='font-size: 0.8rem;']")
      # 「画像サイズを変更」のプルダウンで0.8を選択する(問題プレビューと解答プレビュー二箇所)
      select('0.8', from: 'question_answer[question_option_attributes][image_size_id]')
      select('0.8', from: 'question_answer[answer_option_attributes][image_size_id]')
      # 画像のwidthが(200*0.8)pxになっていることを確認する
      expect(page).to have_selector(".img-preview-question[style='width: 160px;']")
      expect(page).to have_selector(".img-preview-answer[style='width: 160px;']")
      # 作成ボタンを押すとQuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが1ずつ上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # noticeが表示されていることを確認する
      expect(page).to have_content("・問題は正常に作成されました")
    end

    it 'テキストの入力のみでも、問題作成に成功すること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題作成ページに遷移する
      visit new_group_question_answer_path(@group)
      # フォームの問題エリアと解答エリアに問題と解答を入力する
      fill_in 'question_answer_question', with: @question_answer.question
      fill_in 'question_answer_answer', with: @question_answer.answer
      # 作成ボタンを押すとQuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが1ずつ上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # noticeが表示されていることを確認する
      expect(page).to have_content("・問題は正常に作成されました")
    end

    it '画像のみの入力でも、問題作成に成功すること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題作成ページに遷移する
      visit new_group_question_answer_path(@group)
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 問題と解答の画像選択フォームに画像を添付する
      attach_file('question_answer[question_option_attributes][image]', image_path, make_visible: true)
      attach_file('question_answer[answer_option_attributes][image]', image_path, make_visible: true)
      # 作成ボタンを押すとQuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが1ずつ上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # noticeが表示されていることを確認する
      expect(page).to have_content("・問題は正常に作成されました")
    end

    it '複数回問題を作成すると、1回目はRecordモデルのカウントが増加するが、2回目以降はRecordモデルのカウントが増加しないこと' do
      question_answers = FactoryBot.build_list(:question_answer, 3, user_id: @user.id, group_id: @group.id)
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題作成ページに遷移する
      visit new_group_question_answer_path(@group)
      # フォームの問題エリアと解答エリアに問題と解答を入力する(1回目)
      fill_in 'question_answer_question', with: @question_answer.question
      fill_in 'question_answer_answer', with: @question_answer.answer
      # 作成ボタンを押すと、Recordモデルのカウントが1増加する
      expect{
        find('input[name="commit"]').click
      }.to change { Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # 以降、問題作成を3回繰り返す
      question_answers.each do |question_answer|
        # フォームの問題エリアと解答エリアに問題と解答を入力する(2回目以降)
        fill_in 'question_answer_question', with: question_answer.question
        fill_in 'question_answer_answer', with: question_answer.answer
        # 作成ボタンを押しても、Recordモデルのカウントが増加しないことを確認する
        expect{
          find('input[name="commit"]').click
        }.not_to change { Record.count }
        # 問題作成ページに遷移していることを確認する
        expect(current_path).to eq new_group_question_answer_path(@group)
      end
    end
  end

  context '問題作成に失敗した時' do
    it '問題エリアにテキストと画像どちらも入力していない場合、問題作成に失敗し、エラーメッセージが表示されること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題作成ページに遷移する
      visit new_group_question_answer_path(@group)
      # フォームの解答エリアのみに入力を行う
      fill_in 'question_answer_answer', with: @question_answer.answer
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 解答の画像選択フォームに画像を添付する
      attach_file('question_answer[answer_option_attributes][image]', image_path, make_visible: true)
      # 解答プレビューの「文字サイズを変更」のプルダウンで0.8を選択する
      select('0.8', from: 'question_answer[answer_option_attributes][font_size_id]')
      # 解答プレビューの「画像サイズを変更」のプルダウンで0.8を選択する
      select('0.8', from: 'question_answer[answer_option_attributes][image_size_id]')
      # 作成ボタンを押しても、QuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが変化しないことを確認する
      expect{
        find('input[name="commit"]').click
      }.not_to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }
      # newテンプレートがrenderされていることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 解答のプレビューエリアに入力したテキストが存在することを確認する
      expect(
        find("#answer-preview__textarea").text
      ).to eq @question_answer.answer
      # プルダウンが0.8が選択されたままになっていることを確認する(文字サイズと画像サイズ両方)
      expect(page).to have_select('question_answer_answer_option_attributes_font_size_id', selected: '0.8')
      expect(page).to have_select('question_answer_answer_option_attributes_image_size_id', selected: '0.8')
      # プレビューエリアのテキストの文字サイズにプルダウンで選択した0.8が反映されていることを確認する
      expect(page).to have_selector("#answer-preview__textarea[style='font-size: 0.8rem;']")
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content("Question text or image is indispensable")
    end

    it '解答エリアにテキストと画像どちらも入力していない場合、問題作成に失敗し、エラーメッセージが表示されること' do
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題作成ページに遷移する
      visit new_group_question_answer_path(@group)
      # フォームの問題エリアのみに入力を行う
      fill_in 'question_answer_question', with: @question_answer.question
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 問題の画像選択フォームに画像を添付する
      attach_file('question_answer[question_option_attributes][image]', image_path, make_visible: true)
      # 問題プレビューの「文字サイズを変更」のプルダウンで0.8を選択する
      select('0.8', from: 'question_answer[question_option_attributes][font_size_id]')
      # 問題プレビューの「画像サイズを変更」のプルダウンで0.8を選択する
      select('0.8', from: 'question_answer[question_option_attributes][image_size_id]')
      # 作成ボタンを押しても、QuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが変化しないことを確認する
      expect{
        find('input[name="commit"]').click
      }.not_to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }
      # newテンプレートがrenderされていることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 問題のプレビューエリアに入力したテキストが存在することを確認する
      expect(
        find("#question-preview__textarea").text
      ).to eq @question_answer.question
      # プルダウンが0.8が選択されたままになっていることを確認する(文字サイズと画像サイズ両方)
      expect(page).to have_select('question_answer_question_option_attributes_font_size_id', selected: '0.8')
      expect(page).to have_select('question_answer_question_option_attributes_image_size_id', selected: '0.8')
      # プレビューエリアのテキストの文字サイズにプルダウンで選択した0.8が反映されていることを確認する
      expect(page).to have_selector("#question-preview__textarea[style='font-size: 0.8rem;']")
      # 作成ボタンを押しても、QuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが変化しないことを確認する
      expect{
        find('input[name="commit"]').click
      }.not_to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content("Answer text or image is indispensable")
    end
  end
  
end
