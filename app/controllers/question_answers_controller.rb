class QuestionAnswersController < ApplicationController
  before_action :set_group
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy, :reset, :remove]
  before_action :set_session, only: [:destroy, :reset, :remove]

  def index
    @question_answers = @group.question_answers.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @question_answer = QuestionAnswer.new
    @question_answer.build_question_option
    @question_answer.build_answer_option
  end

  def create
    @question_answer = QuestionAnswer.new(nested_form_params)
    ActiveRecord::Base.transaction do
      # 次の一行で3つのテーブル: question_answers, question_options, answer_optionsに同時保存
      @question_answer.save!
      # repetition_algorithmsテーブルに保存
      RepetitionAlgorithm.create!(interval: 0, easiness_factor: 200, question_answer_id: @question_answer.id)
      # recordsテーブルに保存or更新
      Record.record_create_count(current_user.id)
    end
    redirect_to new_group_question_answer_path(@group), notice: '・問題は正常に作成されました'
  rescue StandardError => e
    @question_answer = e.record
    render 'new'
  end

  def edit
  end

  def update
    if @question_answer.update(nested_form_params.except(:display_date, :memory_level, :repeat_count))
      redirect_to url_of_specific_question_position_on_management_page
    else
      render 'edit'
    end
  end

  def destroy
    if @question_answer.destroy
      redirect_back(fallback_location: root_path)
    else
      redirect_to url_of_specific_question_position_on_management_page, notice: '問題の削除に失敗しました'
    end
  end

  def review
    @question_answers = @group.question_answers.where('display_date <= ?', Date.today).limit(10)
  end

  # change_dateは挙動確認用。アプリリリース時には削除。
  def change_date
    @question_answers = @group.question_answers.where('display_date <= ?', params[:date]).limit(10)
    @date = params[:date]
  end

  # 問題を投稿した時の状態にリセットするアクション
  def reset
    ActiveRecord::Base.transaction do
      @question_answer.update(display_date: Date.today, memory_level: 0, repeat_count: 0)
      @question_answer.repetition_algorithm.update(interval: 0, easiness_factor: 200)
    end
    redirect_to url_of_specific_question_position_on_management_page, notice: '問題は初期状態にリセットされました'
  rescue StandardError => e
    redirect_to url_of_specific_question_position_on_management_page, notice: '問題のリセットに失敗しました'
  end

  # 問題を復習周期から外して、復習ページに表示されないようにするアクション
  def remove
    if @question_answer.update(display_date: Date.today + 100.year)
      redirect_to url_of_specific_question_position_on_management_page, notice: '問題を復習周期から外しました'
    else
      redirect_to url_of_specific_question_position_on_management_page, notice: '問題を復習周期から外すのに失敗しました'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_question_answer
    @question_answer = QuestionAnswer.find(params[:id])
  end

  def set_session
    session[:qa_id] = @question_answer.id
  end

  def nested_form_params
    params.require(:question_answer).permit(:question, :answer,
                                            question_option_attributes: [:image, :font_size_id, :image_size_id, :id],
                                            answer_option_attributes: [:image, :font_size_id, :image_size_id, :id])
          .merge(display_date: Date.today, memory_level: 0, repeat_count: 0, user_id: current_user.id, group_id: params[:group_id])
  end

  # 問題管理ページの、特定の問題の位置に遷移するためのurl
  def url_of_specific_question_position_on_management_page
    # ?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1} この部分は特定の問題が、ページネーションで分割したどのページに存在するかを考慮して遷移するための記述。
    "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1}#link-#{@question_answer.id}"
  end
end
