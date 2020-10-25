class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'は英字と数字の両方を含めてください' }, on: :create
  validates :nickname, presence: true

  has_many :groups
  has_many :question_answers
  has_many :records
  has_one :option
  has_many :likes
  has_many :liked_shares, through: :likes, source: :share
end
