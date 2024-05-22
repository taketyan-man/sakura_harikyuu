module HostSupport
  module Request
    def host_is
      host =  FactoryBot.create(:host) 
      post booking_host_login_path, params: {
        session: { password: host.password }
      }
    end
  end
end
 
RSpec.configure do |config|
  config.include HostSupport::Request, type: :request
end