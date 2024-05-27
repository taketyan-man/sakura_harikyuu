require 'rails_helper'

RSpec.describe "Host", type: :request do
  describe '#index' do
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
        day: "今日ああ"
        time: "8:00"
      }
      expect(flash[:notice]).to eq(["日時が正しく入力されていません。"])
      get host_new_path, params: {
        day: "#{Date.today.to_s}",
        time: "8:00"
      }
      expect(flash[:notice]).to eq(["当日は選択できません","正しい日付を選択してください"])
      get host_new_path, params: {
        day: "#{(Date.current >> 2).to_s}",
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

      end
    end
  end
end