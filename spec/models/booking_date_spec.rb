require 'rails_helper' # 設定ファイルrails_helper.rbを読み込むコードが全テストにあります

RSpec.describe BookingDate, type: :model do # Bookモデルのテストコードをブロック内に書いていきます
  # ここにBookモデルのテストコードを書いていきます
  it "trueであるとき、falseになること" do # itの後にNG時に表示される "説明文" を書く
    expect(true).to eq(true)
    # expect(テスト対象コード).to マッチャー(想定テスト結果)
    # マッチャーとはマッチ(一致)するかを判定する道具です
    # マッチャーはここでは==で一致判定するeqをつかっています
  end

  it "Bookモデルをnewしたとき、nilではないこと" do
    expect(BookingDate.new).not_to eq(nil)
  end
end