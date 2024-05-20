class BookingDate < ApplicationRecord
  validates :tell, presence:  true, numericality: true, format: { with: /\A0\d{9,10}\z/ }
  validates :menu, presence: true
  validates :name, presence: true
  validates :date_time, uniqueness: true
  validates :s_time, presence: true
  validates :e_time, presence: true

  validate :date_before_start
  validate :date_current_today
  validate :date_three_month_end

  def date_before_start
    errors.add(:day, "は過去の日付は選択できません") if day < Date.current
  end

 def date_current_today
    errors.add(:day, "は当日は選択できません。予約画面から正しい日付を選択してください。") if day < (Date.current + 1)
  end

  def date_three_month_end
    errors.add(:day, "は3ヶ月以降の日付は選択できません") if (Date.current >> 3) < day
  end
end
