module QuestionAnswersHelper
  # 復習までの日数を、dateに応じて条件分岐して値を返すメソッド
  def display_date_until_review(date)
    if date >= 0 && date <= 100
      "#{date}"
    elsif date < 0
      "0"
    else
      "--"
    end
  end
end
