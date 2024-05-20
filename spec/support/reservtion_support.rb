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
    def reservation(booking)
      post login_path, params: { session: { email:    user.email,
                                            password: user.password } }
    end
  end
end
 
RSpec.configure do |config|
  config.include ReservationSupport::System, type: :system
  config.include ReservationSupport::Request, type: :request
end