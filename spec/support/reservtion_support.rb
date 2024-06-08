module ReservationSupport
  module System
    def booking_new_rand()
      row_rand = rand(1..27)
      row = all('tbody tr')[row_rand]
      weekday = Date.today.wday
      rule_rand = rand(0..(6 - weekday))
      row.all('a', text: '○')[rule_rand].click
      @time_test = times[row_rand - 1]
      @week_test = Date.today + rule_rand + 1
    end

    def reservation()
      visit booking_date_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")
      fill_in 'booking_date_name', with: 'テスト'
      fill_in 'booking_date_tell', with: '0' * 11
      select  'ボディケア 120分',  from: 'booking_date_menu'
      select 'アロマオイル 20分', from: 'booking_date_option'

      click_button '予約する'
    end

    def reservation_rand()
      @random_date = Date.today + rand(1..59)
      @random_wday = @random_date.wday
      @random_time_index = rand(0..21)
      random_time = times[@random_time_index]
      random_menu = menus.sample
      random_option = options.sample
  
      visit booking_date_new_path(day: "#{@random_date.to_s}", time: "#{random_time}")

      fill_in 'booking_date_name', with: 'テスト'
      fill_in 'booking_date_tell', with: '0' * 11
      select "#{random_menu}", from: 'booking_date_menu'
      select "#{random_option}", from: 'booking_date_option'

      click_button '予約する'
      check_menu(random_menu, random_option)
      
      visit booking_date_path(start_date: "#{@random_date.to_s}")
      if @random_wday == 0
        @random_wday = 8
      else
        @random_wday += 1
      end
      @random_time_index += 2
    end

    def check_menu(random_menu, random_option)
      menu_index = menus.index(random_menu)
      option_index = options.index(random_option)
      if option_index == 1
        if menu_index < 4
          return @times = 4
        elsif menu_index < 6
          return @times = 5
        elsif menu_index <= 8
          return @times = 6
        end
      elsif option_index == 0
        if menu_index < 4
          return @times = 3
        elsif menu_index < 6
          return @times = 4
        elsif menu_index <= 8
          return @times = 5
        end
      end
    end

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
               "21:00"
              ]
    end

    def menus 
      menus = [
        "ボディケア 60分",
        "鍼灸マッサージ 60分",
        "美容鍼 60分",
        "期間限定 60分",
        "鍼灸マッサージ 90分",
        "ボディケア 90分",
        "ボディケア 120分",
        "鍼灸マッサージ 120分"
      ]
    end

    def options
      options = [
        "なし",
        "アロマオイル 20分"
      ]
    end
  end

  module Request
    def reservation()
      post booking_dates_path, params: { booking_date: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00",
        name: "モデル",
        tell: "00000000000",
        menu: 2,
        option: 0,
        s_time: "8:00"
      } }
    end
  end
end
 
RSpec.configure do |config|
  config.include ReservationSupport::System, type: :system
  config.include ReservationSupport::Request, type: :request
end