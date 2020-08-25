class RepetitionAlgorithmService
  attr_accessor :review_params, :question_answer, :repetition_algorithm, :memory_level, :repeat_count

  def initialize(review_params, question_answer, repetition_algorithm, memory_level, repeat_count)
    @review_params = review_params
    @question_answer = question_answer
    @repetition_algorithm = repetition_algorithm
    @memory_level = memory_level
    @repeat_count = repeat_count
  end

  def execute_repetition_algorithm_considering_conditional_branch(repeat, memory)
    if repeat.to_i == 0
      case memory
      when "1"
        repetition_algorithm_if_repeat_count_equal_0(1, -20)
      when "2"
        repetition_algorithm_if_repeat_count_equal_0(1, -15)
      when "3"
        repetition_algorithm_if_repeat_count_equal_0(2, 0)
      when "4"
        repetition_algorithm_if_repeat_count_equal_0(3, 20)
      end
    end
  end

  private

  def repetition_algorithm_if_repeat_count_equal_0(next_interval, difference_of_ef)
    @review_params[:interval] = next_interval
    @review_params[:easiness_factor] = @review_params[:easiness_factor].to_i + difference_of_ef
    next_display_date = Date.today.yday + @review_params[:interval]
    @repetition_algorithm.update(interval: @review_params[:interval], easiness_factor: @review_params[:easiness_factor] )
    @question_answer.update(display_date: next_display_date, memory_level: @memory_level, repeat_count: @repeat_count.to_i + 1)
  end

end