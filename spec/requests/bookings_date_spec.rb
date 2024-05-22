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

  describe "POST /create" do
    context 'correct information' do
      let(:reservation_params) { { booking_date: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00",
        name: "竹吉 塁",
        tell: "00000000000",
        menu: 2,
        option: 0,
        s_time: "8:00" 
      } } }

      let(:reservation_params_option) { { booking_date: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00",
        name: "竹吉 塁",
        tell: "00000000000",
        menu: 2,
        option: 1,
        s_time: "8:00"
      } } }

      it 'should save booking correcting information' do
        expect {
          post booking_dates_path, params: reservation_params
        }.to change(BookingDate, :count).by 5
      end

      it 'should save booking correcting information and option' do
        expect {
          post booking_dates_path, params: reservation_params_option
        }.to change(BookingDate, :count).by 6
      end

      it 'should not save when double booking' do
        post booking_dates_path, params: reservation_params
        expect {
          post booking_dates_path, params: { booking_date: {
            day: "#{Date.tomorrow.to_s}",
            time: "10:00",
            name: "竹吉 塁",
            tell: "00000000000",
            menu: 2,
            option: 0,
            s_time: "10:00"
          } }
        }.to_not change(BookingDate, :count)
      end
    end

    context 'incorrect information' do
      let(:reservation_params_menu_nil) { { booking_date: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00",
        name: "竹吉 塁",
        tell: "00000000000",
        menu: nil,
        option: 0,
        s_time: "8:00" 
      } } }

      let(:reservation_params) { { booking_date: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00",
        name: "",
        tell: "",
        menu: nil,
        option: 0,
        s_time: "8:00" 
      } } }

      it 'should not save booking incorrecting information' do
        expect {
          post booking_dates_path, params: reservation_params
        }.to_not change(BookingDate, :count)
      end

      it 'should not save booking menu nil' do
        expect {
          post booking_dates_path, params:
            reservation_params_menu_nil
        }.to_not change(BookingDate, :count)
      end

      it 'should not save booking not equal time and s_time' do
        expect {
          post booking_dates_path,  params:
            reservation_params_equal_time_s_time
        }.to_not change(BookingDate, :count)
      end
    end
  end

  describe 'DELETE /delete' do
    context 'correct information' do
      before do
        reservation()
      end
      it 'should destroy booking correct information' do
        expect {
          post booking_delete_path ,params: {
            date_time: "#{Date.tomorrow.to_s}" + "8:00",
            name: "モデル",
            tell: "00000000000"
          }
        }.to change(BookingDate, :count).by -5
      end
    end

    context 'incorrect information' do
      before do
        reservation()
      end

      it 'should destroy booking correct date_time and inncorrect name' do
        expect {
          post booking_delete_path, params: {
            date_time: "#{Date.tomorrow.to_s}" + "8:00",
            name: "",
            tell: "00000000000"
          }
        }.to_not change(BookingDate, :count)
      end
    end
  end
end