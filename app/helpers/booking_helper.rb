module BookingHelper
  def times
    times = ["8:00",
             "8:30",
             "9:00",
             "9:30",
             "10:00",
             "10:30",
             "11:00",
             "11:30",
             "12:00",
             "12:30",
             "13:00",
             "13:30",
             "14:00",
             "14:30",
             "15:00",
             "15:30",
             "16:00",
             "16:30",
             "17:00",
             "17:30",
             "18:00",
             "18:30",
             "19:00",
             "19:30",
             "20:00",
             "20:30",
             "21:00"]
  end

  def check_reservation(reservations, day, time)
    result = false
    reservations_count = reservations.count
    # 取得した予約データにdayとtimeが一致する場合はtrue,一致しない場合はfalseを返します
    if reservations_count > 1
      reservations.each do |reservation|
        result = reservation[:day].strftime("%Y-%m-%d") == (day.strftime("%Y-%m-%d")) && times[reservation[:time]] == (time)
        return result if result
      end
    elsif reservations_count == 1
      result = reservations[0][:day].strftime("%Y-%m-%d") == (day.strftime("%Y-%m-%d")) && times[reservation[:time]] == (time)
      return result if result
    end
    return result = false
  end
end
