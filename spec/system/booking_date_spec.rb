require "rails_helper"

RSpec.describe "booking_dates", type: :system do
  it "GET /booking_date" do
    visit "/booking_date" # /booksへHTTPメソッドGETでアクセス
    expect(page).to have_text("16:00") # 表示されたページに Books という文字があることを確認
  end
end