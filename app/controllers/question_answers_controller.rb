class QuestionAnswersController < ApplicationController
  before_action :set_group
  before_action :move_to_root_if_different_user
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy, :reset, :remove]

  def index
    # ransackで利用する検索オブジェクトを生成。
    @q = @group.question_answers.ransack(params[:q])
    @question_answers = @q.result.includes(question_option: { image_attachment: :blob }, answer_option: { image_attachment: :blob }).page(params[:page]).per(10)
    set_question_answer_column
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
      RepetitionAlgorithm.create!(interval: 0, easiness_factor: 250, question_answer_id: @question_answer.id)
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
      # ?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1} この部分は特定の問題が、ページネーションで分割したどのページに存在するかを考慮して遷移するための記述。
      redirect_to "/groups/#{@group.id}/question_answers/?page=#{@group.question_answers.where('id<?', @question_answer.id).count / 10 + 1}#link-#{@question_answer.id}"
    else
      render 'edit'
    end
  end

  def destroy
    if @question_answer.destroy
      redirect_back(fallback_location: root_path)
    else
      set_session
      redirect_to back_to_specific_question_position, alert: '問題の削除に失敗しました'
    end
  end

  def review
    @question_answers = @group.question_answers.includes(:repetition_algorithm, question_option: { image_attachment: :blob }, answer_option: { image_attachment: :blob })
                              .where('display_date <= ?', Date.today)
                              .references(:repetition_algorithm, question_option: { image_attachment: :blob }, answer_option: { image_attachment: :blob })
                              .limit(10)
  end

  # change_dateは挙動確認用。アプリリリース時には削除。
  def change_date
    @question_answers = @group.question_answers.includes(:repetition_algorithm, question_option: { image_attachment: :blob }, answer_option: { image_attachment: :blob })
                              .where('display_date <= ?', params[:date])
                              .references(:repetition_algorithm, question_option: { image_attachment: :blob }, answer_option: { image_attachment: :blob })
                              .limit(10)
    @date = params[:date]
  end

  # 問題を投稿した時の状態にリセットするアクション
  def reset
    ActiveRecord::Base.transaction do
      @question_answer.update!(display_date: Date.today, memory_level: 0, repeat_count: 0)
      @question_answer.repetition_algorithm.update!(interval: 0, easiness_factor: 250)
    end
    redirect_to back_to_specific_question_position
  rescue StandardError => e
    set_session
    redirect_to back_to_specific_question_position, alert: '問題のリセットに失敗しました'
  end

  # 問題を復習周期から外して、復習ページに表示されないようにするアクション
  def remove
    if @question_answer.update(display_date: Date.today + 100.year)
      redirect_to back_to_specific_question_position
    else
      set_session
      redirect_to back_to_specific_question_position, alert: '問題を復習周期から外すのに失敗しました'
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

  def move_to_root_if_different_user
    redirect_to root_path unless current_user.id == @group.user.id
  end

  def set_question_answer_column
    # レコードを取得する際に、memory_levelカラムの値が重複したものは削除し、memory_levelカラムの値を参照して昇順に並べ直す。
    @qa_memory_level = @group.question_answers.select("memory_level").distinct.order(memory_level: "ASC")
    # レコードを取得する際に、repeat_countカラムの値が重複したものは削除し、repeat_countカラムの値を参照して昇順に並べ直す。
    @qa_repeat_count = @group.question_answers.select("repeat_count").distinct.order(repeat_count: "ASC")
  end

  # 問題管理ページの、特定の問題の位置に戻るためのurlを返すメソッド
  def back_to_specific_question_position
    request.referer + "#link-#{@question_answer.id}" || root_path
  end
end
