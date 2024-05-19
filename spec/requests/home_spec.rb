require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe 'GET /' do
    it 'Should get home_path' do
      get home_path
      expect(response).to have_http_status :ok
    end
  end
end