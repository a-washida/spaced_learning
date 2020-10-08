class RepetitionAlgorithmService
  attr_accessor :review_params, :question_answer, :repetition_algorithm, :current_user

  def initialize(review_params, question_answer, repetition_algorithm, current_user)
    @review_params = review_params
    @question_answer = question_answer
    @repetition_algorithm = repetition_algorithm
    @current_user = current_user
  end

  # repeat_countとmemory_levelによる条件分岐を考慮してrepetition_algorithmを実行するメソッド
  def execute_repetition_algorithm_considering_conditional_branch(repeat_count, memory_level)
    if repeat_count.to_i == 0
      case memory_level
      when '1'
        execute_repetition_algorithm_if_repeat_count_equal_0(@current_user.option.interval_of_ml1, -20)
      when '2'
        execute_repetition_algorithm_if_repeat_count_equal_0(@current_user.option.interval_of_ml2, -15)
      when '3'
        execute_repetition_algorithm_if_repeat_count_equal_0(@current_user.option.interval_of_ml3, 0)
      when '4'
        execute_repetition_algorithm_if_repeat_count_equal_0(@current_user.option.interval_of_ml4, 20)
      end
    elsif repeat_count.to_i > 0
      case memory_level
      when '1'
        execute_repetition_algorithm_if_repeat_count_greater_than_0(1, -20, 0)
      when '2'
        execute_repetition_algorithm_if_repeat_count_greater_than_0(2, -15, 0)
      when '3'
        execute_repetition_algorithm_if_repeat_count_greater_than_0(3, 0, 1)
      when '4'
        execute_repetition_algorithm_if_repeat_count_greater_than_0(4, 20, 3)
      end
    end
  end

  private

  # 復習回数が0回の場合のrepetition_algorithmを実行するメソッド
  def execute_repetition_algorithm_if_repeat_count_equal_0(next_interval, difference_of_easiness_factor)
    # 以下一行が、問題を再度復習するまでのインターバルを決める式
    @review_params[:interval] = next_interval
    is_common_part_of_repetition_algorithm(difference_of_easiness_factor)
  end

  # 復習回数が0回より大きいの場合のrepetition_algorithmを実行するメソッド
  def execute_repetition_algorithm_if_repeat_count_greater_than_0(memory_level, difference_of_easiness_factor, bonus_if_memory_level_is_high)
    # 以下二行が、問題を再度復習するまでのインターバルを決める式
    modified_easiness_factor = @review_params[:easiness_factor].to_i - 80 + 28 * memory_level - 2 * memory_level**2
    # 再復習までのインターバルは、(前回のインターバル * modified_easiness_factor/100) + 記憶度が高い場合にはbonus発生。
    @review_params[:interval] = @review_params[:interval].to_f * modified_easiness_factor / 100 + bonus_if_memory_level_is_high
    limit_interval_range_1_to_100
    set_upper_limit_of_interval_if_memory_level_low(memory_level)
    is_common_part_of_repetition_algorithm(difference_of_easiness_factor)
  end

  # 復習回数が0回の場合と、0回よりも大きい場合のrepetition_algorithmの共通部分
  def is_common_part_of_repetition_algorithm(difference_of_easiness_factor)
    # easiness_factorの値を変化させる(memory_levelによってdifference_of_easiness_factorが決まる)
    @review_params[:easiness_factor] = @review_params[:easiness_factor].to_i + difference_of_easiness_factor
    limit_easiness_factor_range_130_to_250
    next_display_date = Date.today + @review_params[:interval].to_i
    ActiveRecord::Base.transaction do
      @repetition_algorithm.update!(interval: @review_params[:interval].round(4), easiness_factor: @review_params[:easiness_factor])
      @question_answer.update!(display_date: next_display_date,
                               memory_level: @review_params[:memory_level],
                               repeat_count: @review_params[:repeat_count].to_i + 1)
      Record.record_review_count(@question_answer.user_id, @review_params[:review_count].to_i)
    end
    "次は#{@repetition_algorithm.interval.floor}日後です"
  rescue StandardError => e
    'エラーが発生しました'
  end

  # easiness_factorの範囲を下限値(130)と上限値(250)に制限するメソッド
  def limit_easiness_factor_range_130_to_250
    @review_params[:easiness_factor] = 130 if @review_params[:easiness_factor] < 130
    @review_params[:easiness_factor] = 250 if @review_params[:easiness_factor] > 250
  end

  # インターバルの範囲を下限値(1)と上限値(100)に制限するメソッド
  def limit_interval_range_1_to_100
    @review_params[:interval] = 1 if @review_params[:interval].to_f < 1
    @review_params[:interval] = 100 if @review_params[:interval].to_f > 100
  end

  # 記憶度が1の時はインターバルの上限を3, 記憶度が2の時はインターバルの上限を7に制限するメソッド
  def set_upper_limit_of_interval_if_memory_level_low(memory_level)
    if memory_level == 1 && @review_params[:interval] > @current_user.option.upper_limit_of_ml1
      @review_params[:interval] = @current_user.option.upper_limit_of_ml1
    end
    if memory_level == 2 && @review_params[:interval] > @current_user.option.upper_limit_of_ml2
      @review_params[:interval] = @current_user.option.upper_limit_of_ml2
    end
  end
end
