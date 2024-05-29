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

      it 'should not save if booking reservation' do
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
    it 'should delete correct information' do
      host_is
      host_create
      post host_booking_delete_path, params: {
        s_time_hour: 8,
        s_time_minute: 0,
        e_time_hour: 12,
        e_time_minute: 30,
        day: "#{Date.tomorrow.to_s}"
      }
      expect(flash[:success]).to eq("該当する予定は削除されました")
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