class Record < ApplicationRecord
  with_options presence: true do
    validates :create_count, numericality: { greater_than_or_equal_to: 0 }
    validates :review_count, numericality: { greater_than_or_equal_to: 0 }
    validates :date, uniqueness: { scope: :user_id }
  end

  belongs_to :user

  # dateカラムが今日の日付と一致しているレコードがあれば、updateを行いcreate_countを1ふやす。無ければcreateを行い新しくレコードを作成する。
  def self.record_create_count(user_id)
    record = Record.find_by(date: Date.today, user_id: user_id)
    if record.present?
      record.update!(create_count: record.create_count + 1)
    else
      Record.create!(create_count: 1, review_count: 0, date: Date.today, user_id: user_id)
    end
  end

  # dateカラムが今日の日付と一致しているレコードがあれば、updateを行いreview_countを1ふやす。無ければcreateを行い新しくレコードを作成する。
  def self.record_review_count(user_id, num)
    record = Record.find_by(date: Date.today, user_id: user_id)
    if record.present?
      record.update!(review_count: record.review_count + num)
    else
      Record.create!(create_count: 0, review_count: 1, date: Date.today, user_id: user_id)
    end
  end

  # キーとしてmonth、date、week_day、create_count、review_countの5つを持ったハッシュを作る。そのハッシュ直近一週間分を配列に格納して返すメソッド
  def self.get_weekly_date_and_record(current_user)
    week_days = ['(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)']
    one_week_ago = Date.today - 6
    date_and_records = []
    records = current_user.records.where(date: one_week_ago..Date.today)

    7.times do |i|
      record_array = []
      records.each do |record|
        record_array.push(record.create_count, record.review_count) if record.date == one_week_ago + i
      end
      date_and_record = { month: (one_week_ago + i).month, date: (one_week_ago + i).day, week_day: week_days[(one_week_ago + i).wday], create_count: record_array[0], review_count: record_array[1] }
      date_and_records.push(date_and_record)
    end
    date_and_records
  end
end
