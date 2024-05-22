require 'rails_helper'

RSpec.describe "Host", type: :request do
  describe '#index' do
    it 'should get host_path' do
      host_is
      get host_path
      expect(response).to have_http_status :ok
    end
  end
end