<h1>さくら鍼灸室</h1>

このサービスはさくら鍼灸室のホームページと予約アプリである

* Ruby-2.7.6
* Rails-7.0.5
* jquery-rails (4.5.1)
* Unicorn
* Nginx
* Test     -RSpec 3.13
* DB       -開発環境-sqlite3 本番環境-MySQL
* インフラ -AWS

サービスのURL<br>
http://sakura-harikyuu.com:3000/
<br><br>
<h2>なぜ作ったか</h2>
依頼者が既存のsaasがとても高くて効果が見れなかったため作って欲しいと依頼されたため
<br><br>
<h2>概要</h2>
<div display="flex">
<image src="./app/assets/images/booking.index.png" width="40%">
<image src="./app/assets/images/booking.new.png" height="240px">
<image src="./app/assets/images/host.new.png" height="240px">
<image src="./app/assets/images/host.index1.png" width="40%">
<image src="./app/assets/images/host.index2.png" width="40%">
</div>
  <br><br>
<h2>ER図</h2>
<image src="./app/assets/images/桜鍼灸　ER図.png" width="540px">
  <br><br>
<h2>こだわった点</h2>
このサイトはwebアプリをあまり慣れてない人が使うのが見込まれるので、すごく単純に作った。<br>
ログインなどでユーザーごとに予約を管理しても良かったが、慣れてない人からしてみれば、<br>
ユーザー登録やユーザーログインは難しいと思った<br>
そのため、ユーザー側は予約しかできないように、一度登録したらホストしか予約を削除できないようにした。
<br><br>

<h2>反省点</h2>
初めてのアプリだったためコードが汚かったりDBが汚いと思う今後は、本場の綺麗な書き方をエッセンスなどを学んでから、<br>
リファクタリングしようと思う。制作時間もだいぶかけてしまった。初めてのことだらけなので、時間をかけてしまった。<br>
今後はもっとスムーズに設計をしっかりして、作り出そうと思った。
<br><br>

<h2>追加情報</h2>
line-bot-api導入！！ホスト側がユーザーが予約した時に通知が欲しいと要望をいただいたので導入しました。<br>
ユーザー側が予約をした場合ホストのLINEに通知が来るように、line-bot-apiのGemを導入しました。<br>
内容としては開始時間、終了時間、名前、日付、予約メニュー、オプションの有無を公式LINEアカウントから送信されるように設計しました。<br>

Rspecの導入!!そもそもtestは書いていなかったがRailsTutorialを見てからtestコードを書こうと決めた。<br>
Rspecを使用した理由は現場で多く使われているためだ。
<br><br>
<h2>参考文献様たち</h2>
https://qiita.com/Takao_/items/b18234b8db4cda97a113<br>
https://qiita.com/sssssatou/items/2e6606e3ddf9b246a0fb


