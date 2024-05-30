require 'rails_helper'

RSpec.describe "Host", type: :request do
  describe 'GET /index' do
    it 'should get host_path' do
      host_is
      get host_path
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /new' do
    it 'should get host_new_path' do
      host_is
      get host_new_path, params: {
        day: "#{Date.tomorrow.to_s}",
        time: "8:00"
      }
      expect(response).to have_http_status :ok
      expect(response.body).to include "#{Date.tomorrow.to_s}"
    end

    it 'should not get host_new_path' do
      host_is
      get host_new_path, params: {
        day: "#{Date.tomorrow.to_s}",
        time: ""
      }
      expect(flash[:notice]).to eq(["正しい日時が入力できてません"])
      get host_new_path, params: {
        day: "今日ああ",
        time: "8:00"
      }
      expect(flash[:notice]).to eq(["日時が正しく入力されていません。"])
      get host_new_path, params: {
        day: "#{Date.today.to_s}",
        time: "8:00"
      }
      expect(flash[:notice]).to eq(["当日は選択できません","正しい日付を選択してください"])
      get host_new_path, params: {
        day: "#{(Date.current - 2).to_s}",
        time: "8:00"
      }
      expect(flash[:notice]).to eq(["過去の日付は選択できません", "正しい日付を選択してください"])
      get host_new_path, params: {
        day: "#{((Date.current >> 2) + 1).to_s}",
        time: "8:00"
      }
      expect(flash[:notice]).to eq(["2ヶ月以降の日付は選択できません。正しい日付を選択してください。"])
    end
  end

  describe 'POST /create' do
    context 'correct informatino' do
      it 'should save with correct information' do
        host_is
        host_create
        expect(flash[:success]).to eq(["予定入力しました。"])
        expect(response).to redirect_to host_path
      end

      it 'should be booking count of flash host save between s_time and e_time' do
        reservation()
        host_is
        post host_create_path, params: {
          s_time_hour: 8,
          s_time_minute: 00,
          e_time_hour: 10,
          e_time_minute: 30,
          day: "#{Date.tomorrow.to_s}"
        }
        expect(flash[:notice].count).to eq(5) 
        expect(flash[:success].count).to eq(1) 
      end
    end

    context 'incorrect informtion' do
      it 'should not save with minute nil' do
        host_is
        post host_create_path, params: {
          day: "#{Date.tomorrow.to_s}",
          s_time_hour: 8,
          e_time_hour: 21,
          time: "8:00"
        }
        expect(flash[:notice]).to eq(["入力方法が間違えています。", "最初からやり直してください。"])
        expect(response).to redirect_to host_new_path(day: "#{Date.tomorrow.to_s}")
      end
    end
  end

  describe 'POST /delete' do
    context 'correct information' do
      it 'should delete correct information' do
        host_is
        host_create
        expect {
          host_delete
        }.to change(BookingDate, :count).by -27
        expect(flash[:success]).to eq("該当する予定は削除されました")
      end

      it 'should not delete booking if booking is between s_time and e_time and should delte host' do
        post booking_dates_path, params: { booking_date: {
          day: "#{Date.tomorrow.to_s}",
          time: "12:00",
          name: "テスト",
          tell: "00000000000",
          menu: 2,
          option: 0,
          s_time: "12:00"
        }}
        expect {
          host_is
          host_create
          host_delete
        }.to_not change(BookingDate, :count)
      end
    end

    context 'incorrect information' do
      it 'should not delete inrcorrect informaiton' do
        host_is
        host_create 
        expect {
          post host_booking_delete_path, params: {
            day: "#{(Date.tomorrow + 1).to_s}",
            s_time_hour: 8,
            s_time_minute: 00,
            e_time_hour: 21,
            e_time_minute: 00
        }}.to_not change(BookingDate, :count)
      end

      it 'should be flash[:notice] if incorrect information' do
        host_is
        host_create
        post host_booking_delete_path, params: {
          day: "#{(Date.tomorrow + 1).to_s}",
          s_time_hour: 8,
          s_time_minute: 00,
          e_time_hour: 21,
          e_time_minute: 00
      } 
      expect(flash[:notice]).to eq("該当する予定がありませんでした")
      end

      it "should be flash[:notice] if nil information" do
        host_is 
        post host_booking_delete_path, params: {
          day: "#{Date.tomorrow.to_s}",
          s_time_hour: 8,
          e_time_hour: 21,
        }
        expect(flash[:notice]).to eq(["入力方法を間違えています。"])
      end
    end
  end

  describe 'POST /host_logout' do
    it "should logout" do
      host_is
      post booking_logout_path
      expect(session[:user_id]).to_not eq(1)
      expect(flash[:notice]).to eq('ホストをログアウトしました')
      expect(response).to redirect_to home_path
    end
  end
end