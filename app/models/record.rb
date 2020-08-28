class Record < ApplicationRecord
  with_options presence: true do
    validates :create_count, numericality: { greater_than_or_equal_to: 0 }
    validates :review_count, numericality: { greater_than_or_equal_to: 0 }
    validates :date, uniqueness: { case_sensitive: true }
  end

  belongs_to :user

  # dateカラムが今日の日付と一致しているレコードがあれば、updateを行いcreate_countを1ふやす。無ければcreateを行い新しくレコードを作成する。
  def self.record_create_count(user_id)
    record = Record.find_by(date: Date.today)
    if record.present?
      record.update!(create_count: record.create_count + 1)
    else
      Record.create!(create_count: 1, review_count: 0, date: Date.today, user_id: user_id)
    end
  end

  # dateカラムが今日の日付と一致しているレコードがあれば、updateを行いreview_countを1ふやす。無ければcreateを行い新しくレコードを作成する。
  def self.record_review_count(user_id, num)
    record = Record.find_by(date: Date.today)
    if record.present?
      record.update!(review_count: record.review_count + num)
    else
      Record.create!(create_count: 0, review_count: 1, date: Date.today, user_id: user_id)
    end
  end
end
