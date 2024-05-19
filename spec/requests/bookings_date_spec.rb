require 'rails_helper'

RSpec.describe "BookingsDate", type: :request do
  describe 'GET index' do
    it 'Should get booking_date_path' do
      get booking_date_path
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /new' do
    it 'should get booking_date_new' do
      get booking_date_new_path , params: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00"
      }
      expect(response).to have_http_status :ok
    end


    it 'should not get booking_date_new_path when not correct day' do
      get booking_date_new_path , params: {
        day: "a",
        time: "8:00"
      }
      expect(flash).to be_any 
    end

    it 'should not get booking_date_new_path when not correct time' do
      get booking_date_new_path , params: {
        day: "#{Date.tomorrow.to_s}",
        time: "24:00"
      }
      expect(flash).to be_any 
    end
  end
end