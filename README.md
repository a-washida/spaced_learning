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
- 問題作成・編集・削除機能
- 入力内容のプレビュー表示機能
- 問題復習機能
- 次回復習までのインターバル計算機能
- 記録表示機能
- 画像ファイルのアップロード機能
- ページネーション機能
- 複数条件を指定した検索機能
- 単体テスト機能
- 結合テスト機能

# 使用技術
- 言語: Ruby, HTML, CSS, JavaScript
- Ruby on Rails
- MySQL
- GitHub
- Amazon S3
- Amazon EC2

# DEMO

## 問題作成機能
問題エリアと解答エリアを入力することで、問題の作成を行います。入力内容は、リアルタイムでプレビュー表示が行われます。プレビュー表示の部分でフォントサイズや画像サイズを変更して、保存する問題の見た目を調整することができます。

![問題作成](https://gyazo.com/133d601d53e8fd27c96b2c4ee6b5701d/raw)

## 問題復習機能
投稿した問題は、復習に適したタイミングで復習ページに表示されます。解答は最初隠れており、クリックすることで解答が表示されます。<br>
記憶度を自己評価するボタンが4つあり、ボタンをクリックすると問題が次に復習ページに表示されるまでの日数が表示されます。「次は2日後です」と表示された場合は、2日後までその問題は復習ページには表示されなくなります。
![問題復習](https://gyazo.com/595f7d91fd53697d7d1666dd4794e3e1/raw)

次に表示されるまでの日数は[こちらの計算式](https://gyazo.com/f223140221aaaf12b9776744cb0b0052/)
を用いて、アプリ側で算出されます。

# 制作背景
- ペルソナ: 学生や、新しいスキルを身に付けたい社会人
- ユーザーが抱える問題: 学習において復習が大事なことは知っているが、復習が継続できない。復習しても記憶に残らない。
- 問題が発生する原因: 過剰復習(短期間で何回も復習してしまう。記憶している場所も復習してしまう)が主な原因の一つであると考えられる。<br>
  - 復習に費やす労力が大きくなるため、継続できない。
  - 忘れる前に復習してしまうため、記憶に残らない。(記憶には忘れかけたものを思い出す過程が効果的であるため)
- 上記の問題の解決策として、適切な復習タイミングで問題を表示する機能を持つアプリケーションを作成した。

# 工夫したポイント
アプリの使いやすさを向上させるために、問題作成や編集時に入力内容をプレビュー表示できるようにした。<br>
プレビュー機能を実装した理由としては、例えばテキストエリアから入力して保存した内容を表示させると、スペースや改行の扱いの違いにより見た目が変わってしまうことがある。また、画像をフォームに取り込んだだけでは、どのように表示されるか確認できない。これらはアプリの使いやすさを維持する上で大きな問題だと感じた。<br>
そこで、JavaScriptを用いてプレビュー機能を実装した。加えて、プルダウンで文字や画像サイズを変更できるようにすることで、使用感の更なる向上を意識した。結果として、問題作成や編集機能は様々な技術を同時に使用した、複雑な実装になってしまった。そのため、作業工程を小さな単位に分割し、一つ一つの工程をしっかり理解しながら実装する、ということを特に意識した。

# 課題や今後実装したい機能
### 課題
- gemなどのコードリーティングの能力を伸ばす
- 可読性・保守性をしっかりと意識したコードを書けるようにする
### 今後実装したい機能
- AWSやDockerなどのインフラ面を充実させる
- 作成した問題を他のユーザーが利用できる場所にアップロードする機能
- 他のユーザーがアップロードした問題を、自分のアカウント内に取り込む機能


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

