# アプリ名
Spaced Learning

# 概要
Spaced Learningは復習をサポートするアプリです。<br>
問題を作成してアプリ内に投稿すると、復習に適切なタイミングで復習ページに問題が表示されます。

# 本番環境
URL: 54.95.50.27<br>
テストアカウント
- メールアドレス：test@test
- パスワード：test28447<br>

# アプリケーションの機能一覧
- ユーザー管理機能
- グループ一覧表示機能
- グループ作成・編集・削除機能
- 問題一覧表示機能
- 問題作成機能
- 問題管理機能(編集・削除・その他復習に関する各種操作)
- 問題復習機能
- 入力内容のプレビュー表示機能
- 次回復習までのインターバル計算機能
- 記録表示機能
- 画像ファイルのアップロード機能
- ページネーション機能
- 複数条件を指定した検索機能
- レスポンシブWebデザインに対応
- 単体テストコード
- 結合テストコード

# 使用技術
- 言語: Ruby, HTML, CSS, JavaScript
- Ruby on Rails
- MySQL
- GitHub
- Amazon EC2, S3

# DEMO
主な3つの機能について紹介します。

## 問題作成機能
問題エリアと解答エリアを入力することで、問題の作成を行います。入力内容は、リアルタイムでプレビュー表示が行われます。プレビュー表示の部分でフォントサイズや画像サイズを変更して、復習の際に表示する問題の見た目を調整することができます。

![問題作成](https://gyazo.com/133d601d53e8fd27c96b2c4ee6b5701d/raw)

## 問題復習機能
作成した問題は、復習に適したタイミングで復習ページに表示されます。解答は最初隠れており、クリックすることで解答が表示されます。<br>
記憶度を自己評価するボタンが4つあり、ボタンをクリックすると問題が次に復習ページに表示されるまでの日数が表示されます。「次は2日後です」と表示された場合は、2日後までその問題は復習ページには表示されなくなります。
![問題復習](https://gyazo.com/595f7d91fd53697d7d1666dd4794e3e1/raw)

次に表示されるまでの日数は[こちらの計算式](https://gyazo.com/f223140221aaaf12b9776744cb0b0052/)
を用いて、アプリ側で算出されます。

## 問題管理機能
作成した問題が一覧表示されます。このページから問題編集や削除、その他復習に関する各種操作を行います。様々な条件を指定して、問題の検索を行うこともできます。
![問題管理](https://gyazo.com/6fcb6d0e1c4b6e3e1c3f91be5090e203/raw)

# 制作背景
このアプリケーションは、学生や新しいスキルを習得したい社会人など、学習意欲の高い層を対象に作成を行いました。解決したい問題としては、学習の際に復習の必要性を感じているが、復習しても記憶に残らない・復習が継続できないという問題を想定しました。この問題に繋がる原因を更に深掘りして考えると、過剰復習が主な原因としてあると感じました。過剰に復習してしまうことで、思い出すという記憶に必要なプロセスの機会が減り記憶に残らないといった問題や、復習の労力が大きくなるので復習の継続が困難になるといった問題に繋がります。そこで、過剰復習を防ぐことが問題解決に繋がると考え、復習に適したタイミングで復習ページに問題を表示する機能を持ったアプリケーションを作成しました。

# 工夫した点
アプリケーションの使いやすさを高めることを意識しました。特に、以下の2点を意識しました。<br>
一点目は問題作成時に、入力内容のプレビュー表示機能と文字・画像サイズの変更機能を追加したことです。これによって、復習時に表示される問題の見た目を、ユーザー側でしっかり制御できるようにしました。<br>
二点目は、スマートフォンでの使用を想定してレスポンシブWebデザインに対応したことです。PCよりもスマートフォンの方がアプリケーションを手軽に利用できるため、スマートフォン対応を行うことで復習を継続しやすいアプリケーションに繋がると考えました。この際、上下スクロールが長くなる部分はタブにしてまとめるなど、使い勝手も意識してレスポンシブ対応を行いました。<br>
上記以外にも、わかりにくい部分には補足を加えたり、画像が小さく見づらい場合はクリックして拡大表示できるなど、使いづらさを感じた部分はできるだけ改善するように意識しました。

# 今後実装したい機能
- 他のユーザーと問題を共有する機能
- ドメイン名確保やサイトのSSL化
- Dockerで環境構築

# テーブル設計

## users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |

### Association
- has_many :groups
- has_many :question_answers
- has_many :records
- has_one :option

## groups テーブル

| Column | Type       | Options                   |
| ------ | ---------- | ------------------------- |
| name   | string     | null: false, unique: true |
| user   | references | foreign_key: true         |

### Association
- belongs_to :user
- has_many :question_answers

## question_answers テーブル

| Column       | Type       | Options           |
| ------------ | ---------- | ----------------- |
| question     | text       | 
| answer       | text       | 
| display_date | date       | null: false       |
| memory_level | integer    | null: false       |
| repeat_count | integer    | null: false       |
| user         | references | foreign_key: true |
| group        | references | foreign_key: true |

### Association
- belongs_to :user
- belongs_to :group
- has_one :question_option
- has_one :answer_option
- has_one :repetition_algorithm

## question_options テーブル

| Column          | Type       | Options           |
| --------------- | ---------- | ----------------- |
| question_answer | references | foreign_key: true |
| font_size_id    | integer    | null: false       |
| image_size_id   | integer    | null: false       |

### Association
- belongs_to :question_answer
- has_one_attached :image
- belongs_to_active_hash :font_size
- belongs_to_active_hash :image_size

## answer_options テーブル

| Column          | Type       | Options           |
| --------------- | ---------- | ----------------- |
| question_answer | references | foreign_key: true |
| font_size_id    | integer    | null: false       |
| image_size_id   | integer    | null: false       |


### Association
- belongs_to :question_answer
- has_one_attached :image
- belongs_to_active_hash :font_size
- belongs_to_active_hash :image_size


## repetition_algorithms テーブル

| Column          | Type       | Options           |
| --------------- | ---------- | ----------------- |
| interval        | float      | null: false       |
| easiness_factor | integer    | null: false       |
| question_answer | references | foreign_key: true |

### Association
- belongs_to :question_answer

## records テーブル

| Column       | Type       | Options           |
| ------------ | ---------- | ----------------- |
| create_count | integer    | null: false       |
| review_count | integer    | null: false       |
| date         | date       | null: false       |
| user         | references | foreign_key: true |

### Association
- belongs_to :user

## options テーブル

| Column             | Type       | Options           |
| ------------------ | ---------- | ----------------- |
| interval_of_ml1    | integer    | null: false       |
| interval_of_ml2    | integer    | null: false       |
| interval_of_ml3    | integer    | null: false       |
| interval_of_ml4    | integer    | null: false       |
| upper_limit_of_ml1 | integer    | null: false       |
| upper_limit_of_ml2 | integer    | null: false       |
| easiness_factor    | integer    | null: false       |
| user               | references | foreign_key: true |

### Association
- belongs_to :user