<h1>さくら鍼灸室</h1>

このサービスはさくら鍼灸室のホームページと予約アプリである

* Ruby-2.7.6
* Rails-7.0.5
* Unicorn
* nginx
* DB -開発環境-sqlite3 本番環境-MySQL
* インフラ　-AWS
<p>サービスのURL</p>
http://sakura-harikyuu.com:3000/

<h2>なぜ作ったか</h2>
依頼者が既存のsaasがとても高くて効果が見れなかったため作って欲しいと依頼されたため

<h2>概要</h2>
<div display="flex">
<image src="./app/assets/images/booking.index.png" width="40%">
<image src="./app/assets/images/booking.new.png" height="240px">
<image src="./app/assets/images/host.new.png" height="240px">
<image src="./app/assets/images/host.index1.png" width="40%">
<image src="./app/assets/images/host.index2.png" width="40%">
</div>

<h2>こだわった点</h2>
このサイトはwebアプリをあまり慣れてない人が使うのが見込まれるので、すごく単純に作った。
ログインなどでユーザーごとに予約を管理しても良かったが、慣れてない人からしてみれば、ユーザー登録やユーザーログインは難しいと思った
そのため、ユーザー側は予約しかできないように、一度登録したらホストしか予約を削除できないようにした。

<h2>反省点</h2>
初めてのアプリだったためコードが汚かったりDBが汚いと思う今後は、本場の綺麗な書き方をエッセンスなどを学んでから、リファクタリングしようと思う。
制作時間もだいぶかけてしまった。初めてのことだらけなので、時間をかけてしまった。今後はもっとスムーズに設計をしっかりして、作り出そうと思った。

<h2>参考文献様たち</h2>
https://qiita.com/Takao_/items/b18234b8db4cda97a113
https://qiita.com/sssssatou/items/2e6606e3ddf9b246a0fb


