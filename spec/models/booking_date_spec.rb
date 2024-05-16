require 'rails_helper' # 設定ファイルrails_helper.rbを読み込むコードが全テストにあります

RSpec.describe BookingDate, type: :model do # Bookモデルのテストコードをブロ

  it "Bookモデルをnewしたとき、nilではないこと" do
    expect(BookingDate.new).not_to eq(nil)
  end
end