module QuestionAnswersHelper
  # font_size_idが存在すればfont_size_idを、存在しなければ6を返すメソッド
  def set_font_size_id(font_size_id)
    if font_size_id.present?
      font_size_id
    else
      6
    end
  end

  # image_size_idが存在すればimage_size_idを、存在しなければ4を返すメソッド
  def set_image_size_id(image_size_id)
    if image_size_id.present?
      image_size_id
    else
      4
    end
  end

  # 復習までの日数を、dateに応じて条件分岐して値を返すメソッド
  def display_date_until_review(date)
    if date >= 0 && date <= 100
      date.to_s
    elsif date < 0
      '0'
    else
      '--'
    end
  end

  # params[:q][:sorts]が存在する場合にparams[:q][:sorts]を返し、その他の場合は""を返すメソッド
  def set_sorts
    # params[:q]が存在しない場合にparams[:q][:sorts]を実行しようとするとNoMethodErrorが発生するため、先にparams[:q].present?の条件判定を挟んでおく。
    if params[:q].present? && params[:q][:sorts].present?
      params[:q][:sorts]
    else
      ''
    end
  end

  # question_answersコントローラーの場合は@group.id、sharesコントローラーの場合は@category_second.idを返すメソッド
  def changeable_value_by_controller
    return @group.id if params[:controller] == 'question_answers'
    return @category_second.id if params[:controller] == 'shares'
  end

  # alertの型が配列の場合は要素を一つずつ<p>タグで囲んで返し、文字列の場合はそのまま返すメソッド
  def set_alert(alert)
    html = ''
    if alert.instance_of?(Array)
      alert.each do |element|
        html += simple_format(element)
      end
    else
      html += alert
    end
    raw(html)
  end
end
