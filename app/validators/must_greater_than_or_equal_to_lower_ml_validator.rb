class MustGreaterThanOrEqualToLowerMlValidator < ActiveModel::EachValidator
  # 記憶度が一つ下の場合の入力値よりも小さな入力が行われた場合にエラーを発生させるカスタムバリデーション
  def validate_each(record, attribute, value)
    case options[:with]
    when '記憶度1'
      return if value >= record.interval_of_ml1
    when '記憶度2'
      return if value >= record.interval_of_ml2
    when '記憶度3'
      return if value >= record.interval_of_ml3
    end
    record.errors.add(attribute, "は#{options[:with]}の場合以上の値を設定してください")
  end
end
