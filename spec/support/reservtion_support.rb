module ReservationSupport
  module System
    def booking_new_rand()
      row_rand = rand(1..27)
      row = all('tbody tr')[row_rand]
      row.all('a', text: '○')[0].click
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