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
  end
end
 
RSpec.configure do |config|
  config.include HostSupport::Request, type: :request
end