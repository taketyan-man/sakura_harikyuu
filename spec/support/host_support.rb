module HostSupport
  module Request
    def host_is
      host =  FactoryBot.create(:host) 
      post booking_host_login_path, params: {
        session: { password: host.password }
      }
    end

    def host_create
      post host_create_path, params: {
        s_time_hour: 8,
        s_time_minute: 00,
        e_time_hour: 21,
        e_time_minute: 00,
        day: "#{Date.tomorrow.to_s}"
      }
    end

    def host_delete
      post host_booking_delete_path, params: {
        s_time_hour: 8,
        s_time_minute: 00,
        e_time_hour: 21,
        e_time_minute: 00,
        day: "#{Date.tomorrow.to_s}"
      }
    end
  end

  module System
    def host_is()
      visit booking_host_path
      fill_in 'session_password', with: 'password' 

      click_button 'ログイン' 
      visit host_path
    end

    def reservation()
      visit booking_date_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")
      fill_in 'booking_date_name', with: 'テスト'
      fill_in 'booking_date_tell', with: '0' * 11
      select  'ボディケア 120分',  from: 'booking_date_menu'
      select 'アロマオイル 20分',  from: 'booking_date_option'

      click_button '予約する'
    end

    def host_reservation()
      visit host_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")

      fill_in 's_time_hour',   with: '08'.to_i
      fill_in 's_time_minute', with: '00'.to_i
      fill_in 'e_time_hour',   with: '21'.to_i
      fill_in 'e_time_minute', with: '00'.to_i

      click_button '予定を入れる'
    end
  end
end
 
RSpec.configure do |config|
  config.include HostSupport::Request, type: :request
  config.include HostSupport::System,  type: :system
end