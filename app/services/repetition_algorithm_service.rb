class RepetitionAlgorithmService
  attr_accessor :review_params, :question_answer, :repetition_algorithm

  def initialize(review_params, question_answer, repetition_algorithm)
    @review_params = review_params
    @question_answer = question_answer
    @repetition_algorithm = repetition_algorithm
  end

  def execute_repetition_algorithm_considering_conditional_branch(repeat_count, memory_level)
    if repeat_count.to_i == 0
      case memory_level
      when "1"
        repetition_algorithm_if_repeat_count_equal_0(1, -20)
      when "2"
        repetition_algorithm_if_repeat_count_equal_0(1, -15)
      when "3"
        repetition_algorithm_if_repeat_count_equal_0(2, 0)
      when "4"
        repetition_algorithm_if_repeat_count_equal_0(3, 20)
      end
    elsif repeat_count.to_i > 0
      case memory_level
      when "1"
        repetition_algorithm_if_repeat_count_greater_than_0(1, -20, 0)
      when "2"
        repetition_algorithm_if_repeat_count_greater_than_0(2, -15, 0)
      when "3"
        repetition_algorithm_if_repeat_count_greater_than_0(3, 0, 1)
      when "4"
        repetition_algorithm_if_repeat_count_greater_than_0(4, 20, 2)
      end
    end
  end

  private

  def repetition_algorithm_if_repeat_count_equal_0(next_interval, difference_of_easiness_factor)
    @review_params[:interval] = next_interval
    is_common_part_of_repetition_algorithm(difference_of_easiness_factor)
  end

  def repetition_algorithm_if_repeat_count_greater_than_0(memory_level, difference_of_easiness_factor, num)
    modified_easiness_factor = @review_params[:easiness_factor].to_i - 80 + 28 * memory_level - 2 * memory_level ** 2
    @review_params[:interval] = @review_params[:interval].to_f * modified_easiness_factor/100 + num
    limit_interval_range_1_to_100()
    is_common_part_of_repetition_algorithm(difference_of_easiness_factor)
  end

  def is_common_part_of_repetition_algorithm(difference_of_easiness_factor)
    @review_params[:easiness_factor] = @review_params[:easiness_factor].to_i + difference_of_easiness_factor
    next_display_date = Date.today.yday + @review_params[:interval].to_i
    next_display_year = Date.today.year
    if Date.new(Date.today.year).leap?
      if next_display_date > 366
        next_display_date -= 366
        next_display_year += 1
      end
    else
      if next_display_date > 365
        next_display_date -= 365
        next_display_year += 1
      end
    end
    ActiveRecord::Base.transaction do
      @repetition_algorithm.update!(interval: @review_params[:interval].round(4), easiness_factor: @review_params[:easiness_factor] )
      @question_answer.update!(display_date: next_display_date, display_year: next_display_year, memory_level: @review_params[:memory_level], repeat_count: @review_params[:repeat_count].to_i + 1)
    end
    return "次は#{@repetition_algorithm.interval.floor}日後です"
    rescue => e
      return "エラーが発生しました"
  end

  def limit_interval_range_1_to_100()
    if @review_params[:interval].to_f > 100
      @review_params[:interval] = 100
    end
    if @review_params[:interval].to_f < 1
      @review_params[:interval] = 1
    end
  end
end