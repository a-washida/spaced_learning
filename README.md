# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation
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
| question     | text       | null: false       |
| answer       | text       | null: false       |
| display_date | integer    | null: false       |
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
| question        | references | foreign_key: true |

### Association
- belongs_to :question_answers

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
