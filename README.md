
# README

# StudyTimeCounter App

## コンセプト　勉強中のアプリわき見抑制
勉強中に他のアプリに気をとられる事を抑制する目的で  
このアプリはフォーカス状態が外れると時間カウンターが止まるようになっています。 

## アプリURL  
https://studytimecounter2-app.onrender.com

## モデルテスト
userモデルテスト結果
https://i.gyazo.com/9cd088acc1da897e71b6d3872a69bc08.png

usersettingモデルテスト結果
https://i.gyazo.com/c8f9be0bfa89892734323874f0a728d8.png


### ・利用方法
1.　ユーザー登録：Topページヘッダーから登録できます。  
　　　　　　　　登録すると累積時間を保存できます。  
2.　勉強時間を計測：「開始」ボタンで時間計測を開始し、「終了」ボタンで計測停止  。  
　　　　　　　　　　途中で休憩したい場合は「休憩」ボタンで計測を一時停止できます。  
　　　　　　　　　　「開始」を再度押して計測をリスタートできます。  
3.　各種設定：Topページヘッダーで休憩モード切替、累積時間確認ができます。  

### ・機能
●アプリわき見抑制機能
　このアプリでないタブを選択してフォーカス状態が外れると時間カウンターが止まります。  
　他のアプリを見る事によるペナルティを作り、誘惑への抑制を狙っています。  

●ユーザー管理機能 
　・ニックネーム  
　・Eメール  
　・パスワード  
　勉強時間の累積、各種設定を保存する為です。  

●ストップウォッチ機能
・開始ボタン(終了ボタン)  
　時間計測開始する、押すと表示が「終了」になります。  
　終了ボタンを押すと計測した時間を保存します。  

・休憩ボタン  
　押すとカウンターが止まり、休憩時間の表示がされます。  
　休憩時間はカウントアップかカウントダウンの
　モード切替が出来ます。  

●各種設定  
・休憩時間設定  
　休憩時間の設定が出来ます。

●勉強時間記録機能  
　これまでの勉強時間の累積を確認できます。   


### ・作成した背景  
　ゲームディレクター桜井政博さんのYouTubeで
　「とにかくやれ」という言葉からインスピレーションを受けて作成
　何かをやらなくてはならない時モチベーションが上がらない
　やる気が出ない、そんな時の対処法が「とにかくやれ」
　あれこれ考えず、すぐにやる
　とは言えそれが出来れば苦労は無いので
　一度手を付けたらその他の誘惑を抑制できる方法は無いかと考えました。
　そこで時間を計測する条件に「アプリがアクティブ状態の時」
　を加え、他のアプリの閲覧にペナルティを付け、誘惑への抑止力を作りました。 
 　デザインは極力シンプルにし、気が散る要素を少なくしています。
  
### 要件定義  
URL  
https://docs.google.com/spreadsheets/d/1ptxiyLg4S5ImzEIbil3VLD9RnU6PJ8Pt/edit#gid=798740072






## usersテーブル
| Column              | Type       | Options                  |
| ------------------- | ---------- | ------------------------ |
| nickname            | string     | null: false              |
| email               | string     | null: false,unique: true |
| encrypted_password  | string     | null: false              |

### Association
has_many :timers
belongs_to :usersettings

## timesテーブル
| Column              | Type       | Options                       |
| ------------------- | ---------- | ----------------------------- |
| user_id             | references | null: false,foreign_key: true |
| duration_seconds    | integer    |                               |

### Association
belongs_to :user

## usersettingsテーブル
| Column              | Type       | Options                       |
| ------------------- | ---------- | ----------------------------- |
| user_id             | references | null: false,foreign_key: true |
| configuration_state | boolean    |                               |
| countdown_time      | integer    |                               |

### Association
belongs_to :user
