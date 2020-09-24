require 'rails_helper'

RSpec.describe '問題作成機能', type: :system do
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
        find('#question-preview__textarea').text
      ).to eq @question_answer.question
      expect(
        find('#answer-preview__textarea').text
      ).to eq @question_answer.answer
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 問題と解答の画像選択フォームに画像を添付する
      attach_file('question_answer[question_option_attributes][image]', image_path, make_visible: true)
      attach_file('question_answer[answer_option_attributes][image]', image_path, make_visible: true)
      # 添付した画像がプレビューエリアに反映されることを確認する
      expect(page).to have_css('.img-preview-question')
      expect(page).to have_css('.img-preview-answer')
      # 「文字サイズを変更」のプルダウンで0.8を選択する(問題プレビューと解答プレビュー二箇所)
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
      expect do
        find('input[name="commit"]').click
      end.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # noticeが表示されていることを確認する
      expect(page).to have_content('・問題は正常に作成されました')
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
      expect  do
        find('input[name="commit"]').click
      end.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # noticeが表示されていることを確認する
      expect(page).to have_content('・問題は正常に作成されました')
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
      expect do
        find('input[name="commit"]').click
      end.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # noticeが表示されていることを確認する
      expect(page).to have_content('・問題は正常に作成されました')
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
      expect  do
        find('input[name="commit"]').click
      end.to change { Record.count }.by(1)
      # 問題作成ページに遷移していることを確認する
      expect(current_path).to eq new_group_question_answer_path(@group)
      # 以降、問題作成を3回繰り返す
      question_answers.each do |question_answer|
        # フォームの問題エリアと解答エリアに問題と解答を入力する(2回目以降)
        fill_in 'question_answer_question', with: question_answer.question
        fill_in 'question_answer_answer', with: question_answer.answer
        # 作成ボタンを押しても、Recordモデルのカウントが増加しないことを確認する
        expect  do
          find('input[name="commit"]').click
        end.not_to change { Record.count }
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
      expect do
        find('input[name="commit"]').click
      end.not_to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }
      # newテンプレートがrenderされていることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 解答のプレビューエリアに入力したテキストが存在することを確認する
      expect(
        find('#answer-preview__textarea').text
      ).to eq @question_answer.answer
      # プルダウンが0.8が選択されたままになっていることを確認する(文字サイズと画像サイズ両方)
      expect(page).to have_select('question_answer_answer_option_attributes_font_size_id', selected: '0.8')
      expect(page).to have_select('question_answer_answer_option_attributes_image_size_id', selected: '0.8')
      # プレビューエリアのテキストの文字サイズにプルダウンで選択した0.8が反映されていることを確認する
      expect(page).to have_selector("#answer-preview__textarea[style='font-size: 0.8rem;']")
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('Question text or image is indispensable')
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
      expect do
        find('input[name="commit"]').click
      end.not_to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }
      # newテンプレートがrenderされていることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 問題のプレビューエリアに入力したテキストが存在することを確認する
      expect(
        find('#question-preview__textarea').text
      ).to eq @question_answer.question
      # プルダウンが0.8が選択されたままになっていることを確認する(文字サイズと画像サイズ両方)
      expect(page).to have_select('question_answer_question_option_attributes_font_size_id', selected: '0.8')
      expect(page).to have_select('question_answer_question_option_attributes_image_size_id', selected: '0.8')
      # プレビューエリアのテキストの文字サイズにプルダウンで選択した0.8が反映されていることを確認する
      expect(page).to have_selector("#question-preview__textarea[style='font-size: 0.8rem;']")
      # 作成ボタンを押しても、QuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルとRecordモデルのカウントが変化しないことを確認する
      expect do
        find('input[name="commit"]').click
      end.not_to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count && Record.count }
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('Answer text or image is indispensable')
    end
  end
end

RSpec.describe '問題編集機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
    @question_answer = FactoryBot.build(:question_answer, user_id: @user.id, group_id: @group.id)
  end

  context '問題編集に成功したとき' do
    it '問題編集に成功すると、問題管理ページにリダイレクトし、編集内容が反映されていること' do
      qa_size_change = FactoryBot.create(:question_answer, :size_change, user_id: @user.id, group_id: @group.id)
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
      # 画面上に、保存したテキストと画像が表示されていることを確認する(問題と解答エリア両方)
      expect(
        find('.display-question-content__textarea').text
      ).to eq qa_size_change.question
      expect(
        find('.display-answer-content__textarea').text
      ).to eq qa_size_change.answer
      expect(page).to have_css('.display-question-content__image')
      expect(page).to have_css('.display-answer-content__image')
      # フォントサイズが0.8rem,画像のwidthが(200*0.8)pxになっていることを確認する(問題と解答エリア両方)
      expect(page).to have_selector(".display-question-content__textarea[style='font-size: 0.8rem;']")
      expect(page).to have_selector(".display-answer-content__textarea[style='font-size: 0.8rem;']")
      expect(page).to have_selector(".display-question-content__image[style='width: 160px;']")
      expect(page).to have_selector(".display-answer-content__image[style='width: 160px;']")
      # 問題管理エリアに表示されている画像のsrc属性を変数に代入する(問題と解答プレビュー両方)
      src_question = find('.display-question-content__image')[:src]
      src_answer = find('.display-answer-content__image')[:src]
      # 画面上に問題編集ページへのリンクが存在しないことを確認する
      expect(page).to have_no_link '問題編集', href: edit_group_question_answer_path(@group, qa_size_change)
      # 画面上に縦三点リーダーのアイコンが存在することを確認する
      expect(page).to have_css('.qa-index-item__img-three-point')
      # 縦三点リーダーのアイコンをクリックする
      find('.qa-index-item__img-three-point').click
      # 画面上に問題編集ページへのリンクが存在することを確認する
      expect(page).to have_link '問題編集', href: edit_group_question_answer_path(@group, qa_size_change)
      # 問題編集のリンクをクリックする
      all('.qa-index-item__management-list a')[0].click
      # 問題編集ページへ遷移していることを確認する
      expect(current_path).to eq edit_group_question_answer_path(@group, qa_size_change)
      # 問題と解答のテキストエリアに、DBに保存した値が入力されている状態になっていることを確認する
      expect(
        find('#question_answer_question').text
      ).to eq qa_size_change.question
      expect(
        find('#question_answer_answer').text
      ).to eq qa_size_change.answer
      # プレビューエリアに、テキストエリアの入力が反映されていることを確認する(問題と解答プレビュー両方)
      expect(
        find('#question-preview__textarea').text
      ).to eq qa_size_change.question
      expect(
        find('#answer-preview__textarea').text
      ).to eq qa_size_change.answer
      # 文字サイズがが0.8remになっていることを確認する
      expect(page).to have_selector("#question-preview__textarea[style='font-size: 0.8rem;']")
      expect(page).to have_selector("#answer-preview__textarea[style='font-size: 0.8rem;']")
      # プレビューエリアに、DBに保存した画像が表示されており、画像のwidthが(200*0.8)pxになっていることを確認する(問題と解答プレビュー両方)
      expect(page).to have_selector(".img-preview-question[style='width: 160px;']")
      expect(page).to have_selector(".img-preview-answer[style='width: 160px;']")
      # 表示されている画像が、問題管理ページに表示されている画像と一致することを確認する
      expect(
        find('.img-preview-question')[:src]
      ).to eq src_question
      expect(
        find('.img-preview-answer')[:src]
      ).to eq src_answer
      # フォームの問題エリアと解答エリアに、編集後の問題と解答を入力する
      fill_in 'question_answer_question', with: @question_answer.question
      fill_in 'question_answer_answer', with: @question_answer.answer
      # 入力内容がプレビューエリアに反映されることを確認する
      expect(
        find('#question-preview__textarea').text
      ).to eq @question_answer.question
      expect(
        find('#answer-preview__textarea').text
      ).to eq @question_answer.answer
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image2.png')
      # 問題と解答の画像選択フォームに画像を添付する
      attach_file('question_answer[question_option_attributes][image]', image_path, make_visible: true)
      attach_file('question_answer[answer_option_attributes][image]', image_path, make_visible: true)
      # 「文字サイズを変更」のプルダウンで1を選択する(問題プレビューと解答プレビュー両方)
      select('1', from: 'question_answer[question_option_attributes][font_size_id]')
      select('1', from: 'question_answer[answer_option_attributes][font_size_id]')
      # 文字サイズがが1remになっていることを確認する
      expect(page).to have_selector("#question-preview__textarea[style='font-size: 1rem;']")
      expect(page).to have_selector("#answer-preview__textarea[style='font-size: 1rem;']")
      # 「画像サイズを変更」のプルダウンで1.0を選択する(問題プレビューと解答プレビュー二箇所)
      select('1.0', from: 'question_answer[question_option_attributes][image_size_id]')
      select('1.0', from: 'question_answer[answer_option_attributes][image_size_id]')
      # 画像のwidthが(200*1.0)pxになっていることを確認する
      expect(page).to have_selector(".img-preview-question[style='width: 200px;']")
      expect(page).to have_selector(".img-preview-answer[style='width: 200px;']")
      # 編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # 問題管理ページの編集した問題の位置に遷移していることを確認する(URIのpathとqueryとfragmentが一致しているか確認)
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}##{uri.fragment}").to eq "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', qa_size_change.id).count / 10 + 1}#link-#{qa_size_change.id}"
      # 編集後のテキストが表示されていることを確認する(問題と解答エリア両方)
      expect(
        find('.display-question-content__textarea').text
      ).to eq @question_answer.question
      expect(
        find('.display-answer-content__textarea').text
      ).to eq @question_answer.answer
      # 表示されている画像が編集前のものと異なっていることを確認する(問題と解答エリア両方)
      expect(
        find('.display-question-content__image')[:src]
      ).not_to eq src_question
      expect(
        find('.display-answer-content__image')[:src]
      ).not_to eq src_answer
      # フォントサイズが1rem,画像のwidthが(200*1.0)pxに変更されていることを確認する(問題と解答エリア両方)
      expect(page).to have_selector(".display-question-content__textarea[style='font-size: 1rem;']")
      expect(page).to have_selector(".display-answer-content__textarea[style='font-size: 1rem;']")
      expect(page).to have_selector(".display-question-content__image[style='width: 200px;']")
      expect(page).to have_selector(".display-answer-content__image[style='width: 200px;']")
    end

    it '編集後の入力がテキストのみでも、問題編集に成功すること' do
      qa_with_no_image = FactoryBot.create(:question_answer, :no_image, user_id: @user.id, group_id: @group.id)
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題管理ページへのリンクをクリックする
      find('.group-panel.js-2').click
      # 問題管理ページへ遷移していることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 縦三点リーダーのアイコンをクリックする
      find('.qa-index-item__img-three-point').click
      # 問題編集のリンクをクリックする
      all('.qa-index-item__management-list a')[0].click
      # 問題編集ページへ遷移していることを確認する
      expect(current_path).to eq edit_group_question_answer_path(@group, qa_with_no_image)
      # フォームの問題エリアと解答エリアに、編集後の問題と解答を入力する
      fill_in 'question_answer_question', with: @question_answer.question
      fill_in 'question_answer_answer', with: @question_answer.answer
      # 編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # 問題管理ページの編集した問題の位置に遷移していることを確認する(URIのpathとqueryとfragmentが一致しているか確認)
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}##{uri.fragment}").to eq "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', qa_with_no_image.id).count / 10 + 1}#link-#{qa_with_no_image.id}"
      # 編集後のテキストが表示されていることを確認する(問題と解答エリア両方)
      expect(
        find('.display-question-content__textarea').text
      ).to eq @question_answer.question
      expect(
        find('.display-answer-content__textarea').text
      ).to eq @question_answer.answer
    end

    it '編集後の入力が画像のみでも、問題編集に成功すること' do
      qa_with_no_image = FactoryBot.create(:question_answer, :no_image, user_id: @user.id, group_id: @group.id)
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題管理ページへのリンクをクリックする
      find('.group-panel.js-2').click
      # 問題管理ページへ遷移していることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 縦三点リーダーのアイコンをクリックする
      find('.qa-index-item__img-three-point').click
      # 問題編集のリンクをクリックする
      all('.qa-index-item__management-list a')[0].click
      # 問題編集ページへ遷移していることを確認する
      expect(current_path).to eq edit_group_question_answer_path(@group, qa_with_no_image)
      # フォームの問題エリアと解答エリアに、空のテキストを入力する
      fill_in 'question_answer_question', with: ''
      fill_in 'question_answer_answer', with: ''
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 問題と解答の画像選択フォームに画像を添付する
      attach_file('question_answer[question_option_attributes][image]', image_path, make_visible: true)
      attach_file('question_answer[answer_option_attributes][image]', image_path, make_visible: true)
      # 編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # 問題管理ページの編集した問題の位置に遷移していることを確認する(URIのpathとqueryとfragmentが一致しているか確認)
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}##{uri.fragment}").to eq "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', qa_with_no_image.id).count / 10 + 1}#link-#{qa_with_no_image.id}"
      # テキストが表示されていないことを確認する(問題と解答エリア両方)
      expect(
        find('.display-question-content__textarea', visible: false).text
      ).to eq ''
      expect(
        find('.display-answer-content__textarea', visible: false).text
      ).to eq ''
      # 添付した画像が表示されていることを確認する(問題と解答エリア両方)
      expect(page).to have_css('.display-question-content__image')
      expect(page).to have_css('.display-answer-content__image')
    end
  end

  context '問題編集に失敗した時' do
    it '問題エリアの入力にテキストも画像も存在しない場合、問題編集に失敗すること' do
      qa_with_no_image = FactoryBot.create(:question_answer, :no_image, user_id: @user.id, group_id: @group.id)
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題管理ページへのリンクをクリックする
      find('.group-panel.js-2').click
      # 問題管理ページへ遷移していることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 縦三点リーダーのアイコンをクリックする
      find('.qa-index-item__img-three-point').click
      # 問題編集のリンクをクリックする
      all('.qa-index-item__management-list a')[0].click
      # 問題編集ページへ遷移していることを確認する
      expect(current_path).to eq edit_group_question_answer_path(@group, qa_with_no_image)
      # フォームの問題エリアのテキストエリア に、空のテキストを入力する
      fill_in 'question_answer_question', with: ''
      # 編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # editテンプレートがrenderされていることを確認する
      expect(current_path).to eq group_question_answer_path(@group, qa_with_no_image)
      # フォームの問題エリアのテキストエリアに、テキストが存在しないことを確認する
      expect(
        find('#question_answer_question').text
      ).to eq ''
      # フォームの解答エリアのテキストエリアに、テキストが存在することを確認する
      expect(
        find('#question_answer_answer').text
      ).to eq qa_with_no_image.answer
      # 問題プレビューにテキストが存在しないことを確認する
      expect(
        find('#question-preview__textarea', visible: false).text
      ).to eq ''
      # 解答プレビューにテキストが存在することを確認する
      expect(
        find('#answer-preview__textarea').text
      ).to eq qa_with_no_image.answer
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('Question text or image is indispensable')
    end

    it '解答エリアの入力にテキストも画像も存在しない場合、問題編集に失敗すること' do
      qa_with_no_image = FactoryBot.create(:question_answer, :no_image, user_id: @user.id, group_id: @group.id)
      # サインインする
      login(@user)
      # トップページに遷移していることを確認する
      expect(current_path).to eq root_path
      # 問題管理ページへのリンクをクリックする
      find('.group-panel.js-2').click
      # 問題管理ページへ遷移していることを確認する
      expect(current_path).to eq group_question_answers_path(@group)
      # 縦三点リーダーのアイコンをクリックする
      find('.qa-index-item__img-three-point').click
      # 問題編集のリンクをクリックする
      all('.qa-index-item__management-list a')[0].click
      # 問題編集ページへ遷移していることを確認する
      expect(current_path).to eq edit_group_question_answer_path(@group, qa_with_no_image)
      # フォームの解答エリアのテキストエリア に、空のテキストを入力する
      fill_in 'question_answer_answer', with: ''
      # 編集ボタンをクリックしてフォームを送信する
      find('input[name="commit"]').click
      # editテンプレートがrenderされていることを確認する
      expect(current_path).to eq group_question_answer_path(@group, qa_with_no_image)
      # フォームの問題エリアのテキストエリアに、テキストが存在することを確認する
      expect(
        find('#question_answer_question').text
      ).to eq qa_with_no_image.question
      # フォームの解答エリアのテキストエリアに、テキストが存在しないことを確認する
      expect(
        find('#question_answer_answer').text
      ).to eq ''
      # 問題プレビューにテキストが存在することを確認する
      expect(
        find('#question-preview__textarea').text
      ).to eq qa_with_no_image.question
      # 解答プレビューにテキストが存在しないことを確認する
      expect(
        find('#answer-preview__textarea', visible: false).text
      ).to eq ''
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('Answer text or image is indispensable')
    end
  end
end

RSpec.describe '問題削除機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
    @question_answer = FactoryBot.create(:question_answer, user_id: @user.id, group_id: @group.id)
  end

  it '問題削除のリンクをクリックすると、問題が削除されて問題管理ページにリダイレクトバックすること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 問題管理ページのページネーションで分割した1ページ目のURLに遷移する
    visit "/groups/#{@group.id}/question_answers/?page=1"
    # 画面上に、保存したテキストと画像が表示されていることを確認する(問題と解答エリア両方)
    expect(
      find('.display-question-content__textarea').text
    ).to eq @question_answer.question
    expect(
      find('.display-answer-content__textarea').text
    ).to eq @question_answer.answer
    expect(page).to have_css('.display-question-content__image')
    expect(page).to have_css('.display-answer-content__image')
    # 画面上に問題削除のリンクが存在しないことを確認する
    expect(page).to have_no_link '問題削除', href: group_question_answer_path(@group, @question_answer)
    # 縦三点リーダーのアイコンをクリックする
    find('.qa-index-item__img-three-point').click
    # 画面上に問題削除のリンクが存在することを確認する
    expect(page).to have_link '問題削除', href: group_question_answer_path(@group, @question_answer)
    # 問題削除のリンクをクリックすると、QuestionAnswerモデルとQuestionOptionモデルとAnswerOptionモデルとRepetitionAlgorithmモデルのカウントが1ずつ減少することを確認する
    expect do
      click_link('問題削除')
    end.to change { QuestionAnswer.count && QuestionOption.count && AnswerOption.count && RepetitionAlgorithm.count }.by(-1)
    # 問題削除を行ったページにリダイレクトバックしていることを確認
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/groups/#{@group.id}/question_answers/?page=1"
    # 画面上に問題が存在しないことを確認する
    expect(page).to have_no_css('.qa-index-item')
  end
end

RSpec.describe '問題復習機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
    @question_answer = FactoryBot.create(:question_answer, user_id: @user.id, group_id: @group.id)
  end

  it '問題復習ページに遷移すると、問題は表示されているが解答は隠れており、解答欄をクリックすることで解答が表示されること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題復習ページへのリンクが存在することを確認する
    expect(page).to have_link @group.name, href: review_group_question_answers_path(@group)
    # 問題復習ページへのリンクをクリックする
    find('.group-panel.js-0').click
    # 問題復習ページへ遷移していることを確認する
    expect(current_path).to eq review_group_question_answers_path(@group)
    # 問題エリアに保存したテキストと画像が表示されていることを確認する
    expect(
      find('.display-question-content__textarea').text
    ).to eq @question_answer.question
    expect(page).to have_css('.display-question-content__image')
    # 解答エリアに保存したテキストと画像が表示されていないことを確認する
    expect(page).to have_no_content(@question_answer.answer)
    expect(page).to have_no_css('.display-answer-content__image')
    # 解答エリアをクリックする
    find('.review-click').click
    # 解答エリアに保存したテキストと画像が表示されていることを確認する
    expect(
      find('.display-answer-content__textarea').text
    ).to eq @question_answer.answer
    expect(page).to have_css('.display-answer-content__image')
  end

  it '問題復習ページの記憶度ボタンを押すと、次回復習までのインターバルが表示され、ページを更新すると問題が表示されなくなっていること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題復習ページへのリンクをクリックする
    find('.group-panel.js-0').click
    # 問題復習ページへ遷移していることを確認する
    expect(current_path).to eq review_group_question_answers_path(@group)
    # 画面上に記憶度を自己評価する1, 2, 3, 4のボタンが存在することを確認する
    expect(page).to have_css('.review-option__btn.js-0')
    expect(page).to have_css('.review-option__btn.js-1')
    expect(page).to have_css('.review-option__btn.js-2')
    expect(page).to have_css('.review-option__btn.js-3')
    # 「1」のボタンをクリックする
    find('.review-option__btn.js-0').click
    # 画面上に「次は1日後です」と表示されていることを確認する
    expect(page).to have_content('次は1日後です')
    # 「2」のボタンをクリックする
    find('.review-option__btn.js-1').click
    # 画面上に「次は2日後です」と表示されていることを確認する
    expect(page).to have_content('次は2日後です')
    # 「3」のボタンをクリックする
    find('.review-option__btn.js-2').click
    # 画面上に「次は4日後です」と表示されていることを確認する
    expect(page).to have_content('次は4日後です')
    # 「4」のボタンをクリックする
    find('.review-option__btn.js-3').click
    # 画面上に「次は6日後です」と表示されていることを確認する
    expect(page).to have_content('次は6日後です')
    # 「次の問題を表示する」のリンクをクリック
    click_link('次の問題を表示する')
    # 画面上に問題が存在しないことを確認する
    expect(page).to have_no_css('.review-individual-wrap')
  end
end

RSpec.describe '問題管理機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
    @question_answer = FactoryBot.create(:question_answer, user_id: @user.id, group_id: @group.id)
  end

  it '「初期状態にリセット」を実行すると、各種パラメータが問題作成した瞬間の状態と等しくなること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題復習ページへのリンクが存在することを確認する
    expect(page).to have_link @group.name, href: review_group_question_answers_path(@group)
    # 問題復習ページへのリンクをクリックする
    find('.group-panel.js-0').click
    # 問題復習ページへ遷移していることを確認する
    expect(current_path).to eq review_group_question_answers_path(@group)
    # 「4」のボタンをクリックする
    find('.review-option__btn.js-3').click
    # 画面上に「次は6日後です」と表示されていることを確認する
    expect(page).to have_content('次は6日後です')
    # 「問題管理」のリンクが存在することを確認する
    expect(page).to have_link '問題管理', href: "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1}#link-#{@question_answer.id}"
    # 「問題管理」のリンクをクリックする
    click_link('問題管理')
    # 問題管理ページの特定の問題の位置に遷移していることを確認する(URIのpathとqueryとfragmentが一致しているか確認)
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}##{uri.fragment}").to eq "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1}#link-#{@question_answer.id}"
    # 復習までの日数が「6」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[0].text
    ).to eq '6'
    # 記憶度が「4」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[1].text
    ).to eq '4'
    # 復習回数が「1」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[2].text
    ).to eq '1'
    # 画面上に「初期状態にリセット」のリンクが存在しないことを確認する
    expect(page).to have_no_link '初期状態にリセット', href: reset_group_question_answer_path(@group, @question_answer)
    # 縦三点リーダーのアイコンをクリックする
    find('.qa-index-item__img-three-point').click
    # 画面上に「初期状態にリセット」のリンクが存在することを確認する
    expect(page).to have_link '初期状態にリセット', href: reset_group_question_answer_path(@group, @question_answer)
    # 「初期状態にリセット」のリンクをクリックする
    click_link('初期状態にリセット')
    # 問題管理ページの、リセットを行った問題の位置に遷移していることを確認する(URIのpathとqueryとfragmentが一致しているか確認)
    uri2 = URI.parse(current_url)
    expect("#{uri2.path}?#{uri2.query}##{uri2.fragment}").to eq "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1}#link-#{@question_answer.id}"
    # 復習までの日数が「0」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[0].text
    ).to eq '0'
    # 記憶度が「0」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[1].text
    ).to eq '0'
    # 復習回数が「0」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[2].text
    ).to eq '0'
  end

  it '「復習周期から外す」のリンクをクリックすると、復習までの日数が「--」と表示されること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 画面上に「復習周期から外す」のリンクが存在しないことを確認する
    expect(page).to have_no_link '復習周期から外す', href: remove_group_question_answer_path(@group, @question_answer)
    # 縦三点リーダーのアイコンをクリックする
    find('.qa-index-item__img-three-point').click
    # 画面上に「復習周期から外す」のリンクが存在することを確認する
    expect(page).to have_link '復習周期から外す', href: remove_group_question_answer_path(@group, @question_answer)
    # 「復習周期から外す」のリンクをクリックする
    click_link('復習周期から外す')
    # 問題管理ページの、「復習周期から外す」を行った問題の位置に遷移していることを確認する(URIのpathとqueryとfragmentが一致しているか確認)
    uri = URI.parse(current_url)
    expect("#{uri.path}##{uri.fragment}").to eq "/groups/#{@group.id}/question_answers#link-#{@question_answer.id}"
    # 復習までの日数が「--」と表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[0].text
    ).to eq '--'
  end
end

RSpec.describe '問題検索機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
  end

  it 'キーワードを入力して検索すると、キーワードを含む問題のみが表示されること' do
    question_answers = FactoryBot.create_list(:question_answer, 3, user_id: @user.id, group_id: @group.id)
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 問題が3つ作成されていることを確認する
    expect(page).to have_css('.qa-index-item__qa', count: 3)
    # 検索フォームが存在することを確認する
    expect(page).to have_css('.search-form')
    # キーワードの入力欄に、@question_answers[0].questionを入力する
    fill_in 'キーワード', with: question_answers[0].question
    # 検索ボタンをクリックする
    find('input[name="commit"]').click
    # 検索後のページに遷移していることを確認する
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/groups/#{@group.id}/question_answers?q%5Bquestion_or_answer_cont%5D=#{question_answers[0].question}&q%5Bsorts%5D=&q%5Bmemory_level_eq%5D=&q%5Brepeat_count_eq%5D=&commit=%E6%A4%9C%E7%B4%A2"
    # 検索したキーワードが入力された状態が保持されていることを確認する
    expect(
      find('#q_question_or_answer_cont').value
    ).to eq question_answers[0].question
    # 検索したキーワードを含む問題のみが表示されていることを確認する
    expect(page).to have_content(question_answers[0].question)
    expect(page).to have_css('.qa-index-item__qa', count: 1)
  end

  it '並び替え(最終更新日時(新しい順))を行うと、最終更新日時が新しい順に問題が表示されていること' do
    question_answers = FactoryBot.create_list(:question_answer, 3, user_id: @user.id, group_id: @group.id)
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 検索フォームが存在することを確認する
    expect(page).to have_css('.search-form')
    # 並び替えのプルダウンの最終更新日時(新しい順)を選択する
    select('最終更新日時(新しい順)', from: 'q[sorts]')
    # 検索ボタンをクリックする
    find('input[name="commit"]').click
    # 検索後のページに遷移していることを確認する
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/groups/#{@group.id}/question_answers?q%5Bquestion_or_answer_cont%5D=&q%5Bsorts%5D=updated_at+desc&q%5Bmemory_level_eq%5D=&q%5Brepeat_count_eq%5D=&commit=%E6%A4%9C%E7%B4%A2"
    # プルダウンで最終更新日時(新しい順)が選択された状態が保持されていることを確認する
    expect(page).to have_select('q_sorts', selected: '最終更新日時(新しい順)')
    # 最終更新日時が新しい順に問題が表示されていることを確認する
    expect(
      all('.display-question-content__textarea')[0].text
    ).to eq question_answers[2].question
    expect(
      all('.display-question-content__textarea')[1].text
    ).to eq question_answers[1].question
    expect(
      all('.display-question-content__textarea')[2].text
    ).to eq question_answers[0].question
  end

  it '記憶度を選択して検索すると、選択した記憶度の問題のみが表示されていること' do
    # 記憶度0〜4の問題をあらかじめ保存する
    5.times do |i|
      FactoryBot.create(:question_answer, user_id: @user.id, group_id: @group.id, memory_level: i)
    end
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 問題が5つ作成されていることを確認する
    expect(page).to have_css('.qa-index-item__qa', count: 5)
    # 検索フォームが存在することを確認する
    expect(page).to have_css('.search-form')
    # 記憶度のプルダウンの1を選択する
    select('1', from: 'q[memory_level_eq]')
    # 検索ボタンをクリックする
    find('input[name="commit"]').click
    # 検索後のページに遷移していることを確認する
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/groups/#{@group.id}/question_answers?q%5Bquestion_or_answer_cont%5D=&q%5Bsorts%5D=&q%5Bmemory_level_eq%5D=1&q%5Brepeat_count_eq%5D=&commit=%E6%A4%9C%E7%B4%A2"
    # 記憶度のプルダウンで1が選択された状態が保持されていることを確認する
    expect(page).to have_select('q_memory_level_eq', selected: '1')
    # 記憶度が1の問題のみが表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[1].text
    ).to eq '1'
    expect(page).to have_css('.qa-index-item__qa', count: 1)
  end

  it '復習回数を選択して検索すると、選択した復習回数の問題のみが表示されていること' do
    # 記憶度0〜4の問題をあらかじめ保存する
    5.times do |i|
      FactoryBot.create(:question_answer, user_id: @user.id, group_id: @group.id, repeat_count: i)
    end
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 問題が5つ作成されていることを確認する
    expect(page).to have_css('.qa-index-item__qa', count: 5)
    # 検索フォームが存在することを確認する
    expect(page).to have_css('.search-form')
    # 復習回数のプルダウンの1を選択する
    select('1', from: 'q[repeat_count_eq]')
    # 検索ボタンをクリックする
    find('input[name="commit"]').click
    # 検索後のページに遷移していることを確認する
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/groups/#{@group.id}/question_answers?q%5Bquestion_or_answer_cont%5D=&q%5Bsorts%5D=&q%5Bmemory_level_eq%5D=&q%5Brepeat_count_eq%5D=1&commit=%E6%A4%9C%E7%B4%A2"
    # 復習回数のプルダウンで1が選択された状態が保持されていることを確認する
    expect(page).to have_select('q_repeat_count_eq', selected: '1')
    # 復習回数が1の問題のみが表示されていることを確認する
    expect(
      all('.qa-index-item__record span')[2].text
    ).to eq '1'
    expect(page).to have_css('.qa-index-item__qa', count: 1)
  end
end

RSpec.describe '画像の拡大表示機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @group = FactoryBot.create(:group, user_id: @user.id)
    @question_answer = FactoryBot.create(:question_answer, user_id: @user.id, group_id: @group.id)
  end

  it '問題管理ページで、画像をクリックすると拡大表示され、再度クリックすると拡大表示が消えること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 問題エリアに存在する画像をクリックする
    find('.display-question-content__image').click
    # 画像が拡大表示されていることを確認する
    expect(page).to have_css('#image-clone')
    # 画面をクリックする(id="image-target"の要素で画面全域が覆われているので、この要素をクリック)
    find('#image-target').click
    # 拡大表示されていた画像が消えていることを確認する
    expect(page).to have_no_css('#image-clone')
    # 解答エリアに存在する画像をクリックする
    find('.display-answer-content__image').click
    # 画像が拡大表示されていることを確認する
    expect(page).to have_css('#image-clone')
    # 画面をクリックする(id="image-target"の要素で画面全域が覆われているので、この要素をクリック)
    find('#image-target').click
    # 拡大表示されていた画像が消えていることを確認する
    expect(page).to have_no_css('#image-clone')
  end

  it '問題管理ページで検索を行なった先のページで、画像をクリックすると拡大表示され、再度クリックすると拡大表示が消えること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題管理ページへのリンクをクリックする
    find('.group-panel.js-2').click
    # 問題管理ページへ遷移していることを確認する
    expect(current_path).to eq group_question_answers_path(@group)
    # 検索ボタンをクリックする
    find('input[name="commit"]').click
    # 検索後のページに遷移していることを確認する
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq "/groups/#{@group.id}/question_answers?q%5Bquestion_or_answer_cont%5D=&q%5Bsorts%5D=&q%5Bmemory_level_eq%5D=&q%5Brepeat_count_eq%5D=&commit=%E6%A4%9C%E7%B4%A2"
    # 問題エリアに存在する画像をクリックする
    find('.display-question-content__image').click
    # 画像が拡大表示されていることを確認する
    expect(page).to have_css('#image-clone')
    # 画面をクリックする(id="image-target"の要素で画面全域が覆われているので、この要素をクリック)
    find('#image-target').click
    # 拡大表示されていた画像が消えていることを確認する
    expect(page).to have_no_css('#image-clone')
    # 解答エリアに存在する画像をクリックする
    find('.display-answer-content__image').click
    # 画像が拡大表示されていることを確認する
    expect(page).to have_css('#image-clone')
    # 画面をクリックする(id="image-target"の要素で画面全域が覆われているので、この要素をクリック)
    find('#image-target').click
    # 拡大表示されていた画像が消えていることを確認する
    expect(page).to have_no_css('#image-clone')
  end

  it '問題復習ページで、画像をクリックすると拡大表示され、再度クリックすると拡大表示が消えること' do
    # サインインする
    login(@user)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
    # 問題復習ページへのリンクをクリックする
    find('.group-panel.js-0').click
    # 問題復習ページへ遷移していることを確認する
    expect(current_path).to eq review_group_question_answers_path(@group)
    # 問題エリアに存在する画像をクリックする
    find('.display-question-content__image').click
    # 画像が拡大表示されていることを確認する
    expect(page).to have_css('#image-clone')
    # 画面をクリックする(id="image-target"の要素で画面全域が覆われているので、この要素をクリック)
    find('#image-target').click
    # 拡大表示されていた画像が消えていることを確認する
    expect(page).to have_no_css('#image-clone')
    # 解答エリアをクリックする
    find('.review-click').click
    # 解答エリアに存在する画像をクリックする
    find('.display-answer-content__image').click
    # 画像が拡大表示されていることを確認する
    expect(page).to have_css('#image-clone')
    # 画面をクリックする(id="image-target"の要素で画面全域が覆われているので、この要素をクリック)
    find('#image-target').click
    # 拡大表示されていた画像が消えていることを確認する
    expect(page).to have_no_css('#image-clone')
  end
end
