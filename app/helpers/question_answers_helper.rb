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
end
