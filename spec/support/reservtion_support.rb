module ReservationSupport
  module System
    def reservation(booking)
      visit booking_date_path
      click_link   '○'
      fill_in      '名前',     with: booking.name
      fill_in      '電話番号', with: booking.tell
      select       'ボディケア 90分', from: 'メニュー'
      select       'なし',            from: 'オプション'
      click_button '予約する'
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