module HostHelper
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

  def options
    options = [
      "なし",
      "アロマオイル 20分"
    ]
  end

  def menus
    menus = [
      "ボディケア 60分",
      "ボディケア 90分",
      "ボディケア 120分",
      "鍼灸マッサージ 60分",
      "鍼灸マッサージ 90分",
      "鍼灸マッサージ 120分",
      "美容鍼 60分",
      "期間限定 60分"
    ]
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
      result = reservations[0][:day].strftime("%Y-%m-%d") == (day.strftime("%Y-%m-%d")) && reservations[0][:s_time] == (time)
      return result if result
    end
    return result
  end

  def menu_search 
    if @reservation.menu == 10
      @menu = "予定"
    elsif @reservation.menu == 9
      @menu = menus[@reservation.menu - 2]
    elsif  @reservation.menu <= 6
      @menu = menus[@reservation.menu] 
    else 
      @menu = "期待していない値が出ました。"
    end
  end

  def option_search
    if @reservation.option == 0
      @option = "なし"
    elsif @reservation.option == 1
      @option = options[@reservation.option]
    elsif @reservation.option == -1
      @option = ""
    else
      @option = "期待していない値が出ています。"
    end
  end
end
