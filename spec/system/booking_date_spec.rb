require "rails_helper"

RSpec.describe "booking_dates", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "GET /booking_date" do
    before do
      visit booking_date_path
      if Date.today.wday == 0
        click_link("次週")
      end
    end

    it 'should show next week if click 次週' do
      click_link("次週")
      expect(page).to have_text('○', count: 27 * 7)
    end

    it "should get booking_date_new_path correct information" do
      row = all('tbody tr')[1]
      row.all('a', text: '○')[0].click
      day_value = find('#booking_date_day').value
      time_value = find('#booking_date_time').value
      expect(day_value).to eq("#{Date.tomorrow.to_s}")
      expect(time_value).to eq("8:00")
    end

    it 'should show correct inform if random pacth' do
      booking_new_rand
      day_value = find('#booking_date_day').value
      time_value = find('#booking_date_time').value
      expect(day_value).to eq("#{@week_test.to_s}")
      expect(time_value).to eq("#{@time_test}")
    end
  end

  describe 'GET /booking_date_new' do
    before do
      visit booking_date_new_path(day: "#{Date.tomorrow}", time: "8:00")
    end

    it "should show correct day and time" do
      day_value = find('#booking_date_day').value
      time_value = find('#booking_date_time').value
      expect(day_value).to eq("#{Date.tomorrow.to_s}")
      expect(time_value).to eq("8:00")
    end

    context 'correct information' do
      it 'should save correct information' do
        reservation()
        day_value = find('[name=day]')
        menu_value = find('[name=menu]')
        option_value = find('[name=option]')
        expect(day_value.text).to eq("#{Date.tomorrow.to_s}")
        expect(menu_value.text).to eq('ボディケア 120分')
        expect(option_value.text).to eq('アロマオイル 20分')
      end
    end

    context 'incorrect information' do
      it 'should show flash with incorrect information' do    
        click_button '予約する'
        expect(page.body).to include("入力されていないものがあります。")
      end

      it 'should not save double booking' do
        reservation()
        visit booking_date_new_path(day: "#{Date.tomorrow.to_s}", time: "8:00")
        fill_in 'booking_date_name', with: 'テスト'
        fill_in 'booking_date_tell', with: '0' * 11
        select  'ボディケア 120分',  from: 'booking_date_menu'
        select 'アロマオイル 20分', from: 'booking_date_option'
        click_button '予約する'
        expect(page.body).to include("もう予約が入っています。")
        expect(page.body).to include("日時の選択からやり直してください。")
      end
    end

    it 'should change booking_date_path if booking save' do
      reservation()
      visit booking_date_path
      weekday = Date.today.wday
      if weekday == 0
        click_link '次週'
      end
      cell_text = find("table tr:nth-child(2) td:nth-child(#{weekday + 2})").text
      expect(cell_text).to eq('x')
    end

    it 'should change correctly if random booking save' do
      reservation_rand()
      @times.times do |i|
        cell_text = find("table tr:nth-child(#{@random_time_index}) td:nth-child(#{@random_wday})").text
        expect(cell_text).to eq('x')
        @random_time_index += 1
      end
    end
  end

  describe 'GET /booking_date_show' do
    before do
      reservation()
    end

    context 'correct information' do
      it 'should redirect booking_date_path' do
        click_link '完了'
        expect(page.body).to include('予約画面', '2ヶ月先まで予約することができます。')
      end

      it 'should show and not show delete-box if delete-btn click ' do
        expect(page).to have_css('div.delete-box', visible: false)
        delete_btn     = find('a[id=delete-btn]')
        delete_btn.click
        expect(page).to have_css('div.delete-box', visible: true)
        delete_out_btn = find('a[id=delete-content-out]')
        delete_out_btn.click
        expect(page).to have_css('div.delete-box', visible: false)
      end

      it 'should delete booking_date_delete_path' do
        delete_btn = find('a[id=delete-btn]')
        delete_btn.click
        deletebtn = find('input[id=host_button]')
        checkbox = find('#delete_check')
        checkbox.check
        fill_in 'name', with: 'テスト'
        fill_in 'tell', with: "0" * 11
        deletebtn.click
        expect(page.body).to include('予約画面')
      end
    end

    context 'incorrect information' do
      it 'should not delete if not check check-box' do
        delete_btn = find('a[id=delete-btn]')
        delete_btn.click
        deletebtn = find('input[id=host_button]')
        fill_in 'name', with: 'テスト'
        fill_in 'tell', with: "0" * 11
        deletebtn.click
        expect(page).to have_css('div.delete-box', visible: true)
      end

      it 'shold not delete with incorrect information' do
        delete_btn = find('a[id=delete-btn]')
        delete_btn.click
        deletebtn = find('input[id=host_button]')
        checkbox = find('#delete_check')
        checkbox.check
        fill_in 'name', with: ''
        fill_in 'tell', with: "0" * 11
        deletebtn.click
        expect(page.body).to include('以下のエラーが発生しました', '確認用に入力していたものが違います。', 'もう一度最初から入力してください。')
      end
    end
  end
end