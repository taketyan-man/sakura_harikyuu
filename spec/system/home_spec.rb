require 'rails_helper'

RSpec.describe "Home", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'GET /index' do
    before do
      visit home_path
    end
    
    let!(:host) { FactoryBot.create(:host) }

    it 'should have redirecting to booking_date_path' do
      expect(page).to have_link "Web予約", href: booking_date_path
      click_link "Web予約"
      expect(page).to have_content('予約画面')
    end

    it 'should have redirecting booking_host_path' do
      expect(page).to_not have_link "© All rights reserved by takechanmancampany.", href: booking_host_path
      10.times do 
        click_link "© All rights reserved by takechanmancampany."
      end
      expect(page).to have_link "© All rights reserved by takechanmancampany.", href: booking_host_path
      click_link "© All rights reserved by takechanmancampany."
      expect(page).to have_content('ホストログイン')
    end
  end
end